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
expanded class MIXUP_MIDI_META_EVENTS

insert
   LOGGING
   MIXUP_MIDI_EVENT_TYPES

feature {ANY}
   end_of_track_event: MIXUP_MIDI_META_EVENT is
         -- must always be added, and added last, to each track
      once
         create Result.make(meta_event_end_of_track, "", "end_of_track_event")
      end

   sequence_number_event (sequence_number: INTEGER_32): MIXUP_MIDI_META_EVENT is
      require
         sequence_number.in_range(0, 0x0000ffff)
      local
         bytes: STRING; int: INTEGER_8
      do
         create bytes.make_filled('%U', 2)
         int := (sequence_number |>> 8).to_integer_8
         bytes.put(force_character(int), 0)
         int := (sequence_number & 0x000000ff).to_integer_8
         bytes.put(force_character(int), 1)
         create Result.make(meta_event_sequence_number, bytes, "sequence_number_event")
      end

   text_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_text, a_text, "text_event: '" + a_text + "'")
      end

   copyright_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_copyright, a_text, "copyright_event: '" + a_text + "'")
      end

   track_name_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_track_name, a_text, "track_name_event: '" + a_text + "'")
      end

   instrument_name_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_instrument_name, a_text, "instrument_name_event: '" + a_text + "'")
      end

   lyrics_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_lyrics, a_text, "lyrics_event: '" + a_text + "'")
      end

   marker_text_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_marker_text, a_text, "marker_text_event: '" + a_text + "'")
      end

   cue_point_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_cue_point, a_text, "copyright_event: '" + a_text + "'")
      end

   tempo_setting_event_bpm (bpm: INTEGER): MIXUP_MIDI_META_EVENT is
      require
         bpm.in_range(1, 0x00003fff)
      local
         setting: STRING; mpq: INTEGER
      do
         setting := ""
         mpq := bpm_to_mpq(bpm)
         setting.extend(force_character(mpq|>>16))
         setting.extend(force_character(mpq|>> 8))
         setting.extend(force_character(mpq     ))
         create Result.make(meta_event_tempo_setting, setting, "tempo_setting_event: " + bpm.out + " BPM")
      end

   tempo_setting_event_mpq (mpq: INTEGER): MIXUP_MIDI_META_EVENT is
      require
         mpq.in_range(1, 0x00ffffff)
      local
         setting: STRING
      do
         create setting.with_capacity(3)
         setting.extend(force_character(mpq|>>>16))
         setting.extend(force_character(mpq|>>> 8))
         setting.extend(force_character(mpq      ))
         create Result.make(meta_event_tempo_setting, setting, "tempo_setting_event: " + mpq.out + " us/q")
      end

   key_signature_event (keysig, mode: INTEGER): MIXUP_MIDI_META_EVENT is
      require
         keysig.in_range(-7, 7) -- number of alterations: <0 flats, >0 sharps
         mode.in_range(0, 1)    -- major, minor
      local
         setting, desc: STRING
      do
         create setting.with_capacity(2)
         setting.extend(force_character(keysig))
         setting.extend(force_character(mode))

         inspect
            mode
         when 0 then -- major
            inspect
               keysig
            when -7 then
               desc := once "Cb"
            when -6 then
               desc := once "Gb"
            when -5 then
               desc := once "Db"
            when -4 then
               desc := once "Ab"
            when -3 then
               desc := once "Eb"
            when -2 then
               desc := once "Bb"
            when -1 then
               desc := once "F"
            when 0 then
               desc := once "C"
            when 1 then
               desc := once "G"
            when 2 then
               desc := once "D"
            when 3 then
               desc := once "A"
            when 4 then
               desc := once "E"
            when 5 then
               desc := once "B"
            when 6 then
               desc := once "F#"
            when 7 then
               desc := once "C#"
            end
         when 1 then -- minor
            inspect
               keysig
            when -7 then
               desc := once "Abm"
            when -6 then
               desc := once "Ebm"
            when -5 then
               desc := once "Bbm"
            when -4 then
               desc := once "Fm"
            when -3 then
               desc := once "Cm"
            when -2 then
               desc := once "Gm"
            when -1 then
               desc := once "Dm"
            when 0 then
               desc := once "Am"
            when 1 then
               desc := once "Em"
            when 2 then
               desc := once "Bm"
            when 3 then
               desc := once "F#m"
            when 4 then
               desc := once "C#m"
            when 5 then
               desc := once "G#m"
            when 6 then
               desc := once "D#m"
            when 7 then
               desc := once "A#m"
            end
         end

         create Result.make(meta_event_key_signature, setting, "key_signature_event: " + desc)
      end

   time_signature_event (numerator, denominator, metronome_ticks, thirtyseconds_per_quarter: INTEGER): MIXUP_MIDI_META_EVENT is
      require
         numerator > 0
         valid_denominator(denominator)
         metronome_ticks >= 0
         thirtyseconds_per_quarter > 0
      local
         setting, desc: STRING
      do
         create setting.with_capacity(4)
         setting.extend(force_character(numerator))
         inspect
            denominator
         when 1 then
            setting.extend('%/0/')
         when 2 then
            setting.extend('%/1/')
         when 4 then
            setting.extend('%/2/')
         when 8 then
            setting.extend('%/3/')
         when 16 then
            setting.extend('%/4/')
         when 32 then
            setting.extend('%/5/')
         end
         setting.extend(force_character(metronome_ticks))
         setting.extend(force_character(thirtyseconds_per_quarter))

         desc := numerator.out + "/" + denominator.out
         if metronome_ticks > 0 then
            desc.append_string(once ", metronome: every ")
            if metronome_ticks = 1 then
               desc.append_string(once "tick")
            else
               metronome_ticks.append_in(desc)
               desc.append_string(once " ticks")
            end
         end
         if thirtyseconds_per_quarter /= 8 then
            desc.append_string(once ", ")
            thirtyseconds_per_quarter.append_in(desc)
            if thirtyseconds_per_quarter = 1 then
               desc.append_string(once " tick per quarter")
            else
               desc.append_string(once " ticks per quarter")
            end
         end
         create Result.make(meta_event_time_signature, setting, "time_signature_event: " + desc)
      end

   valid_denominator (denominator: INTEGER): BOOLEAN is
      do
         inspect
            denominator
         when 1, 2, 4, 8, 16, 32 then
            Result := True
         else
            check not Result end
         end
      end

   unknown_meta_event (code: INTEGER; data: COLLECTION[INTEGER]): MIXUP_MIDI_META_EVENT is
      require
         code.in_range(0, 255)
         data.for_all(agent (int: INTEGER): BOOLEAN then int.in_range(0, 255) end (?))
      local
         setting: STRING
      do
         create setting.with_capacity(data.count)
         data.for_each(agent (int: INTEGER) is
                       do
                          setting.extend(force_character(int))
                       end (?))
         create Result.make(code, setting, "unknown_meta_event")
      end

feature {}
   force_character (int: INTEGER_32): CHARACTER is
      do
         Result := (int & 0x000000ff).to_character
      end

   bpm_to_mpq (bpm: INTEGER): INTEGER is
         -- Bytes Per Minute => Microseconds Per Quarter
      do
         Result := 60000000 // bpm;
         log.info.put_line(bpm.out + " BPM => " + Result.out + " MPQ")
      end

feature {ANY}
   valid_code (a_code: INTEGER_32): BOOLEAN is
      do
         Result := valid_codes.has(a_code)
      end

feature {}
   valid_codes: AVL_SET[INTEGER_32] is
      once
         create Result.make
         Result.add(meta_event_sequence_number )
         Result.add(meta_event_text            )
         Result.add(meta_event_copyright       )
         Result.add(meta_event_track_name      )
         Result.add(meta_event_instrument_name )
         Result.add(meta_event_lyrics          )
         Result.add(meta_event_marker_text     )
         Result.add(meta_event_cue_point       )
         Result.add(meta_event_channel_prefix  )
         Result.add(meta_event_end_of_track    )
         Result.add(meta_event_tempo_setting   )
         Result.add(meta_event_time_signature  )
         Result.add(meta_event_key_signature   )
      end

end -- class MIXUP_MIDI_META_EVENTS
