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
class MIXUP_MIDI_PLAYER

inherit
   MIXUP_ABSTRACT_PLAYER[MIXUP_MIDI_OUTPUT_STREAM,
                         MIXUP_MIDI_SECTION,
                         MIXUP_MIDI_ITEM,
                         MIXUP_MIDI_VOICE,
                         MIXUP_MIDI_VOICES,
                         MIXUP_MIDI_STAFF,
                         MIXUP_MIDI_INSTRUMENT
                         ]

insert
   MIXUP_MIDI_CONTROLLER_KNOBS
   MIXUP_MIDI_EVENTS
   MIXUP_MIDI_META_EVENTS

create {ANY}
   make, connect_to

feature {ANY}
   name: FIXED_STRING is
      once
         Result := "midi".intern
      end

   native (a_def_source, a_call_source: MIXUP_SOURCE; fn_name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         inspect
            fn_name
         when "midi_instrument" then
            Result := set_midi_instrument(a_call_source, a_context, args)
         when "midi_tempo" then
            Result := set_midi_tempo(a_call_source, a_context, args)
         when "transpose" then
            Result := set_transpose(a_call_source, a_context, args)
         when "midi_mpc_start" then
            Result := set_midi_mpc_start(a_call_source, a_context, args)
         when "midi_mpc_end" then
            Result := set_midi_mpc_end(a_call_source, a_context, args)
         else
            info_at(a_call_source, "MIDI: ignored unknown native function: " + fn_name)
         end
      end

   play_send_events (a_data: MIXUP_EVENT_DATA; a_events: HOARD[FUNCTION[TUPLE[INTEGER_8], MIXUP_MIDI_EVENT]]) is
         -- MIDI-specific
      require
         a_events /= Void
      do
         log.info.put_line("MIDI: send events")
         instruments.reference_at(a_data.instrument).send_events(a_data.start_time, a_data.staff_id, a_data.voice_id, a_events)
      end

   play_send_meta_events (a_data: MIXUP_EVENT_DATA; a_events: HOARD[MIXUP_MIDI_META_EVENT]) is
         -- MIDI-specific
      require
         a_events /= Void
      do
         log.info.put_line("MIDI: send meta events")
         current_section.send_meta_events(a_data.start_time, a_events)
      end

   play_transpose (a_data: MIXUP_EVENT_DATA; a_half_tones: INTEGER_8) is
         -- MIDI-specific
      do
         log.info.put_line("MIDI: send transpose")
         instruments.reference_at(a_data.instrument).transpose(a_data.start_time, a_half_tones)
      end

   play_mpc (a_data: MIXUP_EVENT_DATA; a_knob: MIXUP_MIDI_CONTROLLER_KNOB; a_start_time: INTEGER_64; a_start_value, a_end_value: INTEGER_8) is
         -- MIDI-specific
      do
         log.info.put_line("MIDI: send MPC")
         instruments.reference_at(a_data.instrument).mpc(a_knob, a_start_time * current_section.precision, a_start_value, a_data.start_time * current_section.precision, a_end_value)
      end

feature {} -- native functions
   set_midi_instrument (a_source: MIXUP_SOURCE; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_MIDI_SEND_EVENTS_FACTORY is
      local
         bank, patch: MIXUP_INTEGER
      do
         if args.count /= 2 then
            error_at(a_source, "MIDI: bad argument count")
         elseif not (bank ?:= args.first) then
            error_at(args.first.source, "MIDI: bad argument type")
         elseif not (patch ?:= args.last) then
            error_at(args.last.source, "MIDI: bad argument type")
         else
            bank ::= args.first
            patch ::= args.last
            if not bank.value.in_range(0, 127) then
               error_at(bank.source, "MIDI: bad argument value, expected 0..127 but got " + bank.value.out)
            elseif not patch.value.in_range(0, 127) then
               error_at(patch.source, "MIDI: bad argument value, expected 0..127 but got " + patch.value.out)
            else
               create Result.make(a_source)
               Result.add_event(agent controller_event(?, bank_controller, bank.value.to_integer_8))
               Result.add_event(agent program_change_event(?, patch.value.to_integer_8))
            end
         end
      end

   set_midi_tempo (a_source: MIXUP_SOURCE; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_MIDI_SEND_META_EVENTS_FACTORY is
      local
         bpm: MIXUP_INTEGER
      do
         if args.count /= 1 then
            error_at(a_source, "MIDI: bad argument count")
         elseif not (bpm ?:= args.first) then
            error_at(args.first.source, "MIDI: bad argument type")
         else
            bpm ::= args.first
            if not bpm.value.in_range(0, 0x00003fff) then
               error_at(bpm.source, "MIDI: bad argument value, expected 0..16383 but got " + bpm.value.out)
            else
               create Result.make(a_source)
               Result.add_event(tempo_setting_event(bpm.value.to_integer_32))
            end
         end
      end

   set_transpose (a_source: MIXUP_SOURCE; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_MIDI_TRANSPOSE_FACTORY is
      local
         half_tones: MIXUP_INTEGER
      do
         if args.count /= 1 then
            error_at(a_source, "MIDI: bad argument count")
         elseif not (half_tones ?:= args.first) then
            error_at(args.first.source, "MIDI: bad argument type")
         else
            half_tones ::= args.first
            if not half_tones.value.in_range(-127, 127) then
               error_at(half_tones.source, "MIDI: bad argument value, expected -127..127 but got " + half_tones.value.out)
            else
               create Result.make(a_source, half_tones.value.to_integer_8)
            end
         end
      end

   set_midi_mpc_start (a_source: MIXUP_SOURCE; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_MIDI_MPC_START_FACTORY is
      local
         id, knob: MIXUP_STRING; value: MIXUP_INTEGER
         controller_knob: MIXUP_MIDI_CONTROLLER_KNOB
      do
         if args.count /= 3 then
            error_at(a_source, "MIDI: bad argument count")
         elseif not (id ?:= args.first) then
            error_at(args.first.source, "MIDI: bad argument type")
         elseif not (knob ?:= args.item(args.lower+1)) then
            error_at(args.first.source, "MIDI: bad argument type")
         elseif not (value ?:= args.last) then
            error_at(args.last.source, "MIDI: bad argument type")
         else
            id ::= args.first
            knob ::= args.item(args.lower+1)
            value ::= args.last
            controller_knob := knobs.fast_reference_at(knob.value)
            if controller_knob = Void then
               error_at(knob.source, "MIDI: unknown controller knob: " + knob.value.out)
            elseif not value.value.in_range(0, 127) then
               error_at(value.source, "MIDI: bad argument value, expected 0..127 but got " + value.value.out)
            else
               create Result.make(a_source, controller_knob, value.value.to_integer_8)
               if not id.value.is_empty then
                  mpc_map.put(Result, id.value)
               end
            end
         end
      end

   set_midi_mpc_end (a_source: MIXUP_SOURCE; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_MIDI_MPC_END_FACTORY is
      local
         id: MIXUP_STRING; value: MIXUP_INTEGER
         mpc_start: MIXUP_MIDI_MPC_START_FACTORY
      do
         if args.count /= 2 then
            error_at(a_source, "MIDI: bad argument count")
         elseif not (id ?:= args.first) and then not (mpc_start ?:= args.first) then
            error_at(args.first.source, "MIDI: bad argument type")
         elseif not (value ?:= args.last) then
            error_at(args.last.source, "MIDI: bad argument type")
         else
            value ::= args.last
            if mpc_start ?:= args.first then
               mpc_start ::= args.first
            else
               id ::= args.first
               mpc_start := mpc_map.fast_reference_at(id.value)
            end
            if mpc_start = Void then
               error_at(mpc_start.source, "MIDI: bad argument value, unknown MPC")
            elseif mpc_start.mpc_end /= Void then
               error_at(mpc_start.source, "MIDI: bad argument value, this MPC already has an end point")
            elseif not value.value.in_range(0, 127) then
               error_at(value.source, "MIDI: bad argument value, expected 0..127 but got " + value.value.out)
            else
               create Result.make(a_source, mpc_start, value.value.to_integer_8)
            end
         end
      end

feature {} -- section files management
   build_filename (a_name: ABSTRACT_STRING): STRING is
      do
         Result := a_name.out
         if current_section /= Void then
            current_section.filename_in(Result)
         end
         Result.append(once ".mid")
      end

feature {}
   call_tool (filename: STRING) is
      do
         -- nothing currently (may eventually call some midi synthesizer)
      end

feature {}
   new_instrument (a_name: FIXED_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]): MIXUP_MIDI_INSTRUMENT is
      do
         Result := current_section.new_instrument(context, a_name, voice_staff_ids, instruments.count)
      end

   new_section (section, a_name: ABSTRACT_STRING): MIXUP_MIDI_SECTION is
      do
         create Result.make(section, a_name, current_section)
      end

   new_output (a_filename: ABSTRACT_STRING): MIXUP_MIDI_FILE_WRITE is
      local
         bfw: BINARY_FILE_WRITE
      do
         create bfw.connect_to(a_filename)
         if bfw.is_connected then
            create Result.connect_to(bfw)
         end
      end

feature {}
   connect_to (a_output: like opus_output) is
      require
         a_output.is_connected
      do
         create instruments.make
         opus_output := a_output
      ensure
         opus_output = a_output
         not managed_output
      end

   make is
      do
         managed_output := True
         create instruments.make
      ensure
         opus_output = Void
         managed_output
      end

   mpc_map: HASHED_DICTIONARY[MIXUP_MIDI_MPC_START_FACTORY, FIXED_STRING] is
      once
         create Result.make
      end

end -- class MIXUP_MIDI_PLAYER
