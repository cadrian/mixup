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
class MIXUP_LILYPOND_PLAYER

inherit
   MIXUP_ABSTRACT_PLAYER[MIXUP_LILYPOND_OUTPUT,
                         MIXUP_LILYPOND_SECTION,
                         MIXUP_LILYPOND_ITEM,
                         MIXUP_LILYPOND_VOICE,
                         MIXUP_LILYPOND_VOICES,
                         MIXUP_LILYPOND_STAFF,
                         MIXUP_LILYPOND_INSTRUMENT]

insert
   MIXUP_CONFIGURATION

create {ANY}
   make, connect_to

feature {ANY}
   name: FIXED_STRING is
      once
         Result := "lilypond".intern
      end

   native (a_def_source: MIXUP_SOURCE; a_context: MIXUP_NATIVE_CONTEXT; fn_name: STRING): MIXUP_VALUE is
      local
         str: MIXUP_STRING
      do
         inspect
            fn_name
         when "current_bar_number" then
            create {MIXUP_INTEGER} Result.make(a_context.call_source, bar_number)
         when "string_event" then
            if a_context.args.count /= 1 then
               error_at(a_context.call_source, "Lilypond: bad argument count")
            elseif str ?:= a_context.args.first then
               str ::= a_context.args.first
               check str.value /= Void end
               create {MIXUP_LILYPOND_STRING_EVENT_FACTORY} Result.make(str.source, str.value)
            else
               error_at(a_context.args.first.source, "Lilypond: expected a string")
            end
         when "set_header" then
            if a_context.args.count /= 1 then
               error_at(a_context.call_source, "Lilypond: bad argument count")
            elseif str ?:= a_context.args.first then
               str ::= a_context.args.first
               check str.value /= Void end
               current_section.set_header(str.value)
            else
               error_at(a_context.args.first.source, "Lilypond: expected a string")
            end
         else
            info_at(a_context.call_source, "Lilypond: ignored unknown native function: " + fn_name)
         end
      end

feature {ANY}
   play_string_event (a_data: MIXUP_EVENT_DATA; a_string: FIXED_STRING) is
         -- Lilypond-specific
      require
         a_string /= Void
      do
         log.info.put_line("Lilypond: string event")
         instruments.reference_at(a_data.instrument.name).string_event(a_data.staff_id, a_data.voice_id, a_string)
      end

feature {} -- section files management
   build_filename (a_name: ABSTRACT_STRING): STRING is
      do
         Result := a_name.out
         if current_section /= Void then
            current_section.filename_in(Result)
         end
         Result.append(once ".ly")

         if current_section /= Void then
            current_section.set_body(once "\include %"")
            current_section.set_body(Result)
            current_section.set_body(once "%"%N")
         end
      end

feature {} -- System call to lilypond
   call_tool (filename: STRING) is
      local
         command: STRING
         sys: SYSTEM; status: INTEGER
      do
         command := lilypond_exe_path.item.out
         lilypond_include_directories.do_all(agent (dir: FIXED_STRING; cmd: STRING) is
                                                do
                                                   cmd.append(once " -I ")
                                                   cmd.append(dir)
                                                end (?, command))
         command.append(once " -dresolution=1200 ")
         command.append(filename)
         log.info.put_line("Calling command: %"" + command + "%"")
         status := sys.execute_command(command)
         if status /= 0 then
            log.warning.put_line("Lilypond command failed (exited with status " + status.out + ")")
         end
      end

feature {}
   new_instrument (a_name: FIXED_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]): MIXUP_LILYPOND_INSTRUMENT is
      do
         create Result.make(context, Current, a_name, voice_staff_ids)
      end

   new_section (section, a_name: ABSTRACT_STRING): MIXUP_LILYPOND_SECTION is
      do
         if current_section = Void then
            create Result.make_full(section, a_name)
            Result.set_header(once "mixup")
            Result.set_header(section)
            Result.set_header(once " = %"")
            Result.set_header(a_name)
            Result.set_header(once "%"%N")
         else
            create Result.make_body(section, a_name, current_section)
         end
      end

   new_output (a_filename: ABSTRACT_STRING): MIXUP_LILYPOND_OUTPUT is
      local
         tfw: TEXT_FILE_WRITE
      do
         create tfw.connect_to(a_filename)
         if tfw.is_connected then
            create Result.connect_to(tfw)
         end
      end

feature {}
   connect_to (a_output: OUTPUT_STREAM) is
      require
         a_output.is_connected
      do
         create instruments.make
         create opus_output.connect_to(a_output)
      ensure
         opus_output.stream = a_output
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

invariant
   instruments /= Void

end -- class MIXUP_LILYPOND_PLAYER
