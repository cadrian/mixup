-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
deferred class MIXUP_MIDI_INPUT_STREAM

inherit
   MIXUP_ABSTRACT_INPUT

insert
   MIXUP_MIDI_CONTROLLER_KNOBS
   MIXUP_MIDI_EVENTS
   MIXUP_MIDI_EVENT_TYPES
   MIXUP_MIDI_META_EVENTS
   MIXUP_MIDI_STREAM_CONSTANTS
   LOGGING

feature {ANY}
   has_error: BOOLEAN
      do
         Result := error /= Void
      end

   error: ABSTRACT_STRING

   decode
      require
         decoded = Void
      local
         magic, size, type, tracks_count, division, tracknum, tail: INTEGER_32; tail_ok: BOOLEAN
      do
         magic := read_integer_32(Void)
         if has_error then
         elseif magic /= header_magic then
            error := "Invalid midi file: bad header magic #(1) /= #(2)" # hex(magic) # hex(header_magic)
         else
            size := read_integer_32(Void)
            if has_error then
            elseif size /= header_size then
               error := "Invalid midi file: bad header size #(1) /= #(2)" # hex(size) # hex(header_size)
            else
               type := read_integer_16(Void)
               if has_error then
               elseif type /= header_type_0 and then type /= header_type_1 and then type /= header_type_2 then
                  error := "Invalid midi file: unknown header type #(1)" # &type
               else
                  tracks_count := read_integer_16(Void)
                  if has_error then
                  elseif tracks_count <= 0 then
                     error := "Invalid midi file: bad tracks count: #(1)" # hex(tracks_count)
                  else
                     division := read_integer_16(Void)
                     if has_error then
                     elseif division <= 0 then
                        error := "Invalid midi file: bad division: #(1)" # hex(division)
                     else
                        create decoded.make(type.to_integer_8, division.to_integer_16)
                        from
                           tracknum := 1
                        until
                           has_error or else tracknum > tracks_count
                        loop
                           read_track(decoded, tracknum)
                           tracknum := tracknum + 1
                        end
                        if not has_error then
                           decoded.end_all_tracks
                        end
                     end
                  end
               end
            end
         end
         if not has_error and then not end_of_input then
            tail := read_integer_8(Void)
            if has_error then
               if end_of_input then
                  error := Void
               end
            else
               if tail = 0 then
                  -- an extra 0 does no harm
                  tail_ok := True
               else
                  log.error.put_line("Extra byte: #(1)" # hex(tail))
               end
               from
                  tail := read_integer_8(Void)
               until
                  end_of_input
               loop
                  tail_ok := False -- don't allow more than one extra byte
                  log.error.put_line("Extra byte: #(1)" # hex(tail))
                  tail := read_integer_8(Void)
               end
               if end_of_input and then tail_ok then
                  error := Void
               else
                  error := "Expected end of MIDI stream"
               end
            end
         end
      ensure
         (not has_error) implies decoded /= Void
      end

   decoded: MIXUP_MIDI_FILE

   end_of_input: BOOLEAN
      deferred
      end

feature {}
   read_track (file: MIXUP_MIDI_FILE; tracknum: INTEGER_32)
      require
         file /= Void
         tracknum > 0
         not has_error
         file.track_count = tracknum - 1
      local
         track: MIXUP_MIDI_TRACK
         event: MIXUP_MIDI_CODEC
         magic: INTEGER_32
         length, delta_time, time: INTEGER_64
         tracklen: REFERENCE[INTEGER_64]
      do
         log.trace.put_line("Reading track #(1)" # &tracknum)

         magic := read_integer_32(Void)
         if has_error then
         elseif magic /= track_magic then
            error := "Invalid track #(1): bad track header #(2) /= #(3)" # hex(tracknum) # hex(magic) # hex(track_magic)
         else
            length := read_integer_32(Void)
            if has_error then
               error := "Invalid track #(1): #(2)" # hex(tracknum) # error
            elseif length <= 0 then
               error := "Invalid track #(1): bad length: #(2)" # hex(tracknum) # &length
            else
               log.trace.put_line("track #(1) length: #(2)" # hex(tracknum) # &length)
               create track.make
               from
                  create tracklen
               variant
                  length - tracklen.item
               until
                  has_error or else tracklen.item >= length
               loop
                  delta_time := read_variable(tracklen)
                  log.trace.put_line("dt=#(1)" # delta_time.out)
                  if has_error then
                     error := "Invalid track #(1): #(2)" # hex(tracknum) # error
                  elseif delta_time < 0 then
                     error := "Invalid track #(1): invalid delta_time #(2) (negative)" # hex(tracknum) # hex(delta_time)
                  else
                     event := read_event(tracklen)
                     if has_error then
                        error := "Invalid track #(1): #(2)" # hex(tracknum) # error
                     else
                        time := time + delta_time
                        log.trace.put_line("t=#(1) event=#(2)" # time.out # event.out)
                        track.add_event(time, event)
                     end
                  end
               end
               if has_error then
                  error := "#(1) at track byte #(2)" # error # &(tracklen.item)
               elseif tracklen.item > length then
                  error := "Invalid track #(1): length mismatch #(2) /= #(3)" # hex(tracknum) # &(tracklen.item) # &length
               else
                  file.add_track(track)
               end
            end
         end
      ensure
         (not has_error) implies file.track_count = tracknum
      end

   read_event (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_CODEC
      local
         code: INTEGER_32
      do
         code := read_integer_8(count)
         if has_error then
         else
            Result := decode_event(code, count)
         end
      ensure
         (not has_error) implies Result /= Void
      end

   decode_event (code: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_CODEC
      require
         code.in_range(0, 0x000000ff)
      local
         event_type, channel: INTEGER_32
      do
         if code = event_meta_event then
            event_type := read_integer_8(count)
            if has_error then
            else
               inspect
                  event_type
               when meta_event_sequence_number then
                  Result := read_meta_event_sequence_number(count)
               when meta_event_text then
                  Result := read_meta_event_text(count)
               when meta_event_copyright then
                  Result := read_meta_event_copyright(count)
               when meta_event_track_name then
                  Result := read_meta_event_track_name(count)
               when meta_event_instrument_name then
                  Result := read_meta_event_instrument_name(count)
               when meta_event_lyrics then
                  Result := read_meta_event_lyrics(count)
               when meta_event_marker_text then
                  Result := read_meta_event_marker_text(count)
               when meta_event_cue_point then
                  Result := read_meta_event_cue_point(count)
               when meta_event_channel_prefix then
                  Result := read_meta_event_channel_prefix(count)
               when meta_event_end_of_track then
                  Result := read_meta_event_end_of_track(count)
               when meta_event_tempo_setting then
                  Result := read_meta_event_tempo_setting(count)
               when meta_event_time_signature then
                  Result := read_meta_event_time_signature(count)
               when meta_event_key_signature then
                  Result := read_meta_event_key_signature(count)
               else
                  Result := read_unknown_meta_event(event_type, count)
               end
            end
         else
            event_type := code & 0x000000f0
            channel := code & 0x0000000f
            log.trace.put_line("Read event => event type: #(1) -- channel: #(2)" # hex(event_type) # hex(channel))
            inspect
               event_type
            when event_channel_pressure then
               Result := read_event_channel_pressure(channel, count)
            when event_controller then
               Result := read_event_controller(channel, count)
            when event_key_pressure then
               Result := read_event_key_pressure(channel, count)
            when event_note_off then
               Result := read_event_note_off(channel, count)
            when event_note_on then
               Result := read_event_note_on(channel, count)
            when event_pitch_bend then
               Result := read_event_pitch_bend(channel, count)
            when event_program_change then
               Result := read_event_program_change(channel, count)
            else
               error := "Invalid event: #(1)" # hex(event_type)
            end
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_event_channel_pressure (channel: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_CHANNEL_PRESSURE
      local
         pressure: INTEGER_32
      do
         pressure := read_integer_8(count)
         if has_error then
         elseif pressure > 0x0000007f then
            error := "Invalid CHANNEL PRESSURE event: pressure: #(1)" # hex(pressure)
         else
            create Result.make(channel, pressure)
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_event_controller (channel: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_CONTROLLER
      require
         channel.in_range(0, 15)
      local
         knob: MIXUP_MIDI_CONTROLLER_KNOB
         knob_number, knob_value: INTEGER_32
         fine: BOOLEAN
      do
         knob_number := read_integer_8(count)
         if has_error then
         elseif knob_number > 0x0000007f then
            error := "Invalid knob: #(1)" # hex(knob_number)
         else
            knob_value := read_integer_8(count)
            if has_error then
            elseif knob_value > 0x0000007f then
               error := "Invalid knob value: #(1)" # hex(knob_value)
            else
               inspect
                  knob_number

               -- sliders: MSB, LSB
               when 0 then
                  knob := bank_controller
               when 32 then
                  knob := read_fine(channel, count, fine_bank_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 1 then
                  knob := modulation_wheel_controller
               when 33 then
                  knob := read_fine(channel, count, fine_modulation_wheel_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 2 then
                  knob := breath_controller
               when 34 then
                  knob := read_fine(channel, count, fine_breath_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 4 then
                  knob := foot_controller
               when 36 then
                  knob := read_fine(channel, count, fine_foot_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 5 then
                  knob := portamento_time_controller
               when 37 then
                  knob := read_fine(channel, count, fine_portamento_time_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 7 then
                  knob := channel_volume_controller
               when 39 then
                  knob := read_fine(channel, count, fine_channel_volume_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 8 then
                  knob := balance_controller
               when 40 then
                  knob := read_fine(channel, count, fine_balance_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 10 then
                  knob := pan_controller
               when 42 then
                  knob := read_fine(channel, count, fine_pan_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 11 then
                  knob := expression_controller
               when 43 then
                  knob := read_fine(channel, count, fine_expression_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 12 then
                  knob := effect_1_controller
               when 44 then
                  knob := read_fine(channel, count, fine_effect_1_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 13 then
                  knob := effect_2_controller
               when 45 then
                  knob := read_fine(channel, count, fine_effect_2_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 16 then
                  knob := general_purpose_1_controller
               when 48 then
                  knob := read_fine(channel, count, fine_general_purpose_1_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 17 then
                  knob := general_purpose_2_controller
               when 49 then
                  knob := read_fine(channel, count, fine_general_purpose_2_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 18 then
                  knob := general_purpose_3_controller
               when 50 then
                  knob := read_fine(channel, count, fine_general_purpose_3_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True
               when 19 then
                  knob := general_purpose_4_controller
               when 51 then
                  knob := read_fine(channel, count, fine_general_purpose_4_controller)
                  knob_value := read_fine_value(count, knob_value)
                  fine := True

               -- switches
               when 64 then
                  knob := damper_pedal_controller
               when 65 then
                  knob := portamento_controller
               when 66 then
                  knob := sostenuto_controller
               when 67 then
                  knob := soft_pedal_controller
               when 68 then
                  knob := legato_footswitch_controller

               else
                  error := "Invalid or not supported controller knob: #(1)" # hex(knob_number)
               end
            end
         end

         if not has_error then
            log.trace.put_line("Read knob: #(1)#(2) with value #(3)" # knob.name # (if fine then " (fine)" else "" end) # hex(knob_value))
            create Result.make(channel, knob, knob_value)
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_fine (channel: INTEGER_32; count: REFERENCE[INTEGER_64]; knob: MIXUP_MIDI_CONTROLLER_SLIDER): MIXUP_MIDI_CONTROLLER_KNOB
      require
         not has_error
      local
         byte: INTEGER_32
      do
         byte := read_integer_8(count)
         if has_error then
         elseif byte /= 0 then
            error := "Invalid non-null fine byte: #(1)" # hex(byte)
         else
            byte := read_integer_8(count)
            if has_error then
            elseif byte /= knob.event_type | channel then
               error := "Invalid fine message byte: #(1) /= #(2)" # hex(byte) # hex(knob.event_type | channel)
            else
               Result := knob
            end
         end
      ensure
         (not has_error) implies Result = knob
      end

   read_fine_value (count: REFERENCE[INTEGER_64]; value: INTEGER_32): INTEGER_32
      do
         if has_error then
         else
            Result := read_integer_8(count)
            if has_error then
            elseif Result > 0x0000007f then
               error := "Invalid knob fine value: #(1)" # hex(Result)
            else
               Result := (value |<< 7) | Result
            end
         end
      end

   read_event_key_pressure (channel: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_KEY_PRESSURE
      local
         key, pressure: INTEGER_32
      do
         key := read_integer_8(count)
         if has_error then
         elseif key > 0x0000007f then
            error := "Invalid key: #(1)" # hex(key)
         else
            pressure := read_integer_8(count)
            if has_error then
            elseif pressure > 0x0000007f then
               error := "Invalid pressure: #(1)" # hex(pressure)
            else
               create Result.make(channel, key, pressure)
            end
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_event_note_off (channel: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_NOTE_OFF
      local
         pitch, pressure: INTEGER_32
      do
         pitch := read_integer_8(count)
         if has_error then
         elseif pitch > 0x0000007f then
            error := "Invalid pitch: #(1)" # hex(pitch)
         else
            pressure := read_integer_8(count)
            if has_error then
            elseif pressure > 0x0000007f then
               error := "Invalid pressure: #(1)" # hex(pressure)
            else
               create Result.make(channel, pitch, pressure)
            end
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_event_note_on (channel: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_NOTE_ON
      local
         pitch, pressure: INTEGER_32
      do
         pitch := read_integer_8(count)
         if has_error then
         elseif pitch > 0x0000007f then
            error := "Invalid pitch: #(1)" # hex(pitch)
         else
            pressure := read_integer_8(count)
            if has_error then
            elseif pressure > 0x0000007f then
               error := "Invalid pressure: #(1)" # hex(pressure)
            else
               create Result.make(channel, pitch, pressure)
            end
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_event_pitch_bend (channel: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_PITCH_BEND
      local
         pitch, lsb, msb: INTEGER_32
      do
         lsb := read_integer_8(count)
         if has_error then
         elseif lsb > 0x0000007f then
            error := "Invalid pitch LSB: #(1)" # hex(lsb)
         else
            msb := read_integer_8(count)
            if has_error then
            elseif msb > 0x0000007f then
               error := "Invalid pitch MSB: #(1)" # hex(msb)
            else
               pitch := (msb |<< 7) | lsb
               create Result.make(channel, pitch)
            end
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_event_program_change (channel: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_PROGRAM_CHANGE
      local
         patch: INTEGER_32
      do
         patch := read_integer_8(count)
         if has_error then
         elseif patch > 0x0000007f then
            error := "Invalid program patch: #(1)" # hex(patch)
         else
            create Result.make(channel, patch)
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_meta_event_sequence_number (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         length: INTEGER_64; seqnum: INTEGER_32
      do
         length := read_variable(count)
         if has_error then
         elseif length /= 2 then
            error := "Invalid sequence number: length #(1) /= 2" # &length
         else
            seqnum := read_integer_16(count)
            if has_error then
            else
               Result := sequence_number_event(seqnum)
            end
         end
      end

   meta_text (count: REFERENCE[INTEGER_64]): STRING
      local
         length, i: INTEGER_64; byte: INTEGER_32
      do
         length := read_variable(count)
         if has_error then
         elseif length > 0x000000007fffffff then
            error := "Invalid text: length #(1) does not fit into STRING" # &length
         else
            from
               create Result.with_capacity(length.to_integer_32)
               i := 1
            until
               has_error or else i > length
            loop
               byte := read_integer_8(count)
               if has_error then
               else
                  Result.add_last(byte.to_character)
               end
               i := i + 1
            end
         end
      ensure
         (not has_error) implies Result /= Void
      end

   read_meta_event_text (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         text: STRING
      do
         text := meta_text(count)
         if has_error then
         else
            Result := text_event(text)
         end
      end

   read_meta_event_copyright (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         text: STRING
      do
         text := meta_text(count)
         if has_error then
         else
            Result := copyright_event(text)
         end
      end

   read_meta_event_track_name (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         text: STRING
      do
         text := meta_text(count)
         if has_error then
         else
            Result := track_name_event(text)
         end
      end

   read_meta_event_instrument_name (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         text: STRING
      do
         text := meta_text(count)
         if has_error then
         else
            Result := instrument_name_event(text)
         end
      end

   read_meta_event_lyrics (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         text: STRING
      do
         text := meta_text(count)
         if has_error then
         else
            Result := lyrics_event(text)
         end
      end

   read_meta_event_marker_text (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         text: STRING
      do
         text := meta_text(count)
         if has_error then
         else
            Result := marker_text_event(text)
         end
      end

   read_meta_event_cue_point (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         text: STRING
      do
         text := meta_text(count)
         if has_error then
         else
            Result := cue_point_event(text)
         end
      end

   read_meta_event_channel_prefix (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      do
         error := "channel prefix: not implemented"
      end

   read_meta_event_end_of_track (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         length: INTEGER_64
      do
         length := read_variable(count)
         if has_error then
         elseif length /= 0 then
            error := "Invalid end of track: length #(1) /= 0" # &length
         else
            Result := end_of_track_event
         end
      end

   read_meta_event_tempo_setting (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         length: INTEGER_64; up, low: INTEGER_32
      do
         length := read_variable(count)
         if has_error then
         elseif length /= 3 then
            error := "Invalid tempo setting: length #(1) /= 3" # &length
         else
            up := read_integer_8(count)
            if has_error then
            else
               low := read_integer_16(count)
               if has_error then
               else
                  Result := tempo_setting_event_mpq((up |<< 16) | low)
               end
            end
         end
      end

   read_meta_event_time_signature (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         length: INTEGER_64; n, d, m, t: INTEGER_32
      do
         length := read_variable(count)
         if has_error then
         elseif length /= 4 then
            error := "Invalid time signature setting: length #(1) /= 4" # &length
         else
            n := read_integer_8(count)
            if has_error then
            else
               d := read_integer_8(count)
               if has_error then
               elseif not d.in_range(0, 5) then
                  error := "Invalid time signature setting: denominator #(1) not between 0 and 5" # &length
               else
                  m := read_integer_8(count)
                  if has_error then
                  else
                     t := read_integer_8(count)
                     if has_error then
                     else
                        if t /= 8 then
                           log.info.put_line("Unusual time signature: #(1) 32nds per quarter" # &t)
                        end
                        Result := time_signature_event(n, (2 ^ d.to_integer_8).to_integer_32, m, t)
                     end
                  end
               end
            end
         end
      end

   read_meta_event_key_signature (count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         length: INTEGER_64; keysig, mode: INTEGER_32
      do
         length := read_variable(count)
         if has_error then
         elseif length /= 2 then
            error := "Invalid key signature setting: length #(1) /= 2" # &length
         else
            keysig := read_integer_8(count)
            if keysig >= 0x80 then
               keysig := keysig | 0xffffff00 -- sign extension
            end
            if has_error then
            else
               mode := read_integer_8(count)
               if has_error then
               elseif mode /= 0 and then mode /= 1 then
               error := "Invalid key signature setting: mode #(1) not between 0 and 1" # &keysig
               else
                  Result := key_signature_event(keysig, mode)
               end
            end
         end
      end

   read_unknown_meta_event (event_type: INTEGER_32; count: REFERENCE[INTEGER_64]): MIXUP_MIDI_META_EVENT
      local
         length, i: INTEGER_64; byte: INTEGER_32; data: FAST_ARRAY[INTEGER_32]
      do
         length := read_variable(count)
         if has_error then
         elseif length > 0x000000007fffffff then
            error := "Invalid meta event: length #(1) does not fit into FAST_ARRAY" # &length
         else
            create data.with_capacity(length.to_integer_32)
            from
               i := 1
            until
               has_error or else i > length
            loop
               byte := read_integer_8(count)
               if has_error then
               else
                  data.add_last(byte)
               end
               i := i + 1
            end
            Result := unknown_meta_event(event_type, data)
         end
      end


feature {}
   frozen read_variable (count: REFERENCE[INTEGER_64]): INTEGER_64
      local
         byte: INTEGER_32; done: BOOLEAN
      do
         from
         until
            has_error or else done
         loop
            byte := read_integer_8(count)
            if has_error then
            elseif Result > 0x7f00000000000000 then
               error := "Invalid variable: too big"
            else
               Result := (Result |<< 7) | (byte.to_integer_64 & 0x000000000000007f)
               done := byte < 0x00000080
            end
         end
      end

   frozen read_integer_32 (count: REFERENCE[INTEGER_64]): INTEGER_32
      require
         not has_error
         is_connected
      local
         b: INTEGER_32
      do
         b := read_integer_8(count)
         if not has_error then
            Result := b |<< 24
            b := read_integer_8(count)
            if not has_error then
               Result := Result | (b |<< 16)
               b := read_integer_8(count)
               if not has_error then
                  Result := Result | (b |<< 8)
                  b := read_integer_8(count)
                  if not has_error then
                     Result := Result | b
                  end
               end
            end
         end
      end

   frozen read_integer_16 (count: REFERENCE[INTEGER_64]): INTEGER_32
      require
         is_connected
      local
         b: INTEGER_32
      do
         b := read_integer_8(count)
         if not has_error then
            Result := b |<< 8
            b := read_integer_8(count)
            if not has_error then
               Result := Result | b
            end
         end
      ensure
         Result.in_range(0, 0x0000ffff)
      end

   read_integer_8 (count: REFERENCE[INTEGER_64]): INTEGER_32
      require
         is_connected
      do
         Result := do_read_integer_8
         if count /= Void then
            count.set_item(count.item + 1)
         end
      ensure
         Result.in_range(0, 0x000000ff)
      end

   do_read_integer_8: INTEGER_32
      require
         is_connected
      deferred
      ensure
         Result.in_range(0, 0x000000ff)
      end

   hex (int: INTEGER_64): LAZY_STRING
      do
         create Result.make(agent hex2str(int))
      end

   hex2str (int: INTEGER_64): ABSTRACT_STRING
      local
         s: STRING
      do
         s := ("000000000000000000#(1)" # int.to_hexadecimal).out
         if int.in_range(0, 0x00000000000000ff) then
            s := s.substring(s.upper -  1 - 2, s.upper)
         elseif int.in_range(0, 0x000000000000ffff) then
            s := s.substring(s.upper -  3 - 2, s.upper)
         elseif int.in_range(0, 0x00000000ffffffff) then
            s := s.substring(s.upper -  7 - 2, s.upper)
         else
            s := s.substring(s.upper - 15 - 2, s.upper)
         end
         s.put('x', s.lower + 1)
         Result := s
      end

end -- class MIXUP_MIDI_INPUT_STREAM
