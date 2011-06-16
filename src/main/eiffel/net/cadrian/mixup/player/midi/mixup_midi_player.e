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
         when "set_header" then
            -- ignored
         else
            warning_at(a_call_source, "MIDI: unknown native function: " + fn_name)
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

end -- class MIXUP_MIDI_PLAYER
