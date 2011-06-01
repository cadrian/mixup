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
   MIXUP_CORE_PLAYER

insert
   MIXUP_CONFIGURATION

create {ANY}
   make, connect_to

feature {ANY}
   name: FIXED_STRING is
      once
         Result := "lilypond".intern
      end

   set_context (a_context: MIXUP_CONTEXT) is
      do
         context := a_context
      ensure
         context = a_context
      end

   native (a_source: MIXUP_SOURCE; fn_name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         str: MIXUP_STRING
      do
         inspect
            fn_name
         when "current_bar_number" then
            create {MIXUP_INTEGER} Result.make(a_source, bar_number)
         when "string_event" then
            if args.count /= 1 then
               error_at(a_source, "Lilypond: bad argument count")
            elseif str ?:= args.first then
               str ::= args.first
               check str.value /= Void end
               create {MIXUP_LILYPOND_STRING_EVENT_FACTORY} Result.make(str.source, str.value)
            else
               error_at(args.first.source, "Lilypond: expected a string")
            end
         when "set_header" then
            if args.count /= 1 then
               error_at(a_source, "Lilypond: bad argument count")
            elseif str ?:= args.first then
               str ::= args.first
               check str.value /= Void end
               current_section.set_header(str.value)
            else
               error_at(args.first.source, "Lilypond: expected a string")
            end
         else
            warning_at(a_source, "Lilypond: unknown native function: " + fn_name)
         end
      end

feature {ANY}
   play_set_score (a_name: ABSTRACT_STRING) is
      do
         push_section(once "score", a_name)
      end

   play_end_score is
      do
         pop_section
      end

   play_set_book (a_name: ABSTRACT_STRING) is
      do
         push_section(once "book", a_name)
      end

   play_end_book is
      do
         pop_section
      end

   play_set_partitur (a_name: ABSTRACT_STRING) is
      do
         push_section(once "partitur", a_name)
      end

   play_end_partitur is
      do
         pop_section
      end

   play_set_instrument (a_name: ABSTRACT_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]) is
      local
         inst_name: FIXED_STRING
         instrument: MIXUP_LILYPOND_INSTRUMENT
      do
         inst_name := a_name.intern
         create instrument.make(context, Current, inst_name, voice_staff_ids)
         log.info.put_line("Lilypond: adding instrument: " + a_name.out)
         instruments.add(instrument, inst_name)
         bar_number := 0
      end

   play_start_voices (a_data: MIXUP_EVENT_DATA; voice_ids: TRAVERSABLE[INTEGER]) is
      do
         instruments.reference_at(a_data.instrument).start_voices(a_data.staff_id, a_data.voice_id, voice_ids)
      end

   play_end_voices (a_data: MIXUP_EVENT_DATA) is
      do
         instruments.reference_at(a_data.instrument).end_voices(a_data.staff_id, a_data.voice_id)
      end

   play_set_dynamics (a_data: MIXUP_EVENT_DATA; dynamics, position: ABSTRACT_STRING) is
      do
         log.info.put_line("Lilypond: playing dynamics: " + dynamics.out)
         instruments.reference_at(a_data.instrument).set_dynamics(a_data.staff_id, a_data.voice_id, dynamics, position)
      end

   play_set_note (a_data: MIXUP_EVENT_DATA; note: MIXUP_NOTE) is
      do
         log.info.put_line("Lilypond: playing note: " + note.out)
         instruments.reference_at(a_data.instrument).set_note(a_data.staff_id, a_data.voice_id, a_data.start_time, note)
      end

   play_next_bar (a_data: MIXUP_EVENT_DATA; style: ABSTRACT_STRING) is
      do
         log.info.put_line("Lilypond: playing bar")
         instruments.reference_at(a_data.instrument).next_bar(a_data.staff_id, a_data.voice_id, style)
         bar_number := bar_number + 1
      end

   play_start_beam (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         log.info.put_line("Lilypond: starting beam")
         instruments.reference_at(a_data.instrument).start_beam(a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   play_end_beam (a_data: MIXUP_EVENT_DATA) is
      do
         log.info.put_line("Lilypond: ending beam")
         instruments.reference_at(a_data.instrument).end_beam(a_data.staff_id, a_data.voice_id)
      end

   play_start_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         log.info.put_line("Lilypond: starting slur")
         instruments.reference_at(a_data.instrument).start_slur(a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   play_end_slur (a_data: MIXUP_EVENT_DATA) is
      do
         log.info.put_line("Lilypond: ending slur")
         instruments.reference_at(a_data.instrument).end_slur(a_data.staff_id, a_data.voice_id)
      end

   play_start_phrasing_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         log.info.put_line("Lilypond: starting phrasing slur")
         instruments.reference_at(a_data.instrument).start_phrasing_slur(a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   play_end_phrasing_slur (a_data: MIXUP_EVENT_DATA) is
      do
         log.info.put_line("Lilypond: ending phrasing slur")
         instruments.reference_at(a_data.instrument).end_phrasing_slur(a_data.staff_id, a_data.voice_id)
      end

   play_start_repeat (a_data: MIXUP_EVENT_DATA; volte: INTEGER_64) is
      do
         log.info.put_line("Lilypond: starting repeat x" + volte.out)
         instruments.reference_at(a_data.instrument).start_repeat(a_data.staff_id, a_data.voice_id, volte)
      end

   play_end_repeat (a_data: MIXUP_EVENT_DATA) is
      do
         log.info.put_line("Lilypond: ending repeat")
         instruments.reference_at(a_data.instrument).end_repeat(a_data.staff_id, a_data.voice_id)
      end

   play_string_event (a_data: MIXUP_EVENT_DATA; a_string: FIXED_STRING) is
         -- Lilypond-specific
      require
         a_string /= Void
      do
         log.info.put_line("Lilypond: string event")
         instruments.reference_at(a_data.instrument).string_event(a_data.staff_id, a_data.voice_id, a_string)
      end

feature {} -- section files management
   push_section (section, a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      do
         if current_section = Void then
            create current_section.make_full(section, a_name)
            current_section.set_header("mixup" + section.out + " = %"" + a_name.out + "%"%N")
         else
            create current_section.make_body(section, a_name, current_section)
         end
      end

   pop_section is
      local
         section: like current_section
         filename: STRING
         tfr: TEXT_FILE_WRITE
      do
         instruments.do_all_items(agent {MIXUP_LILYPOND_INSTRUMENT}.generate(current_section))
         instruments.clear_count

         section := current_section
         current_section := section.parent

         if managed_output then
            filename := build_filename(section.name)
            if current_section /= Void then
               current_section.set_body(once "\include %"")
               current_section.set_body(filename)
               current_section.set_body(once "%"%N")
            end
            create tfr.connect_to(filename)
            if tfr.is_connected then
               section.generate(tfr)
               tfr.disconnect
            end
            if current_section = Void then
               call_lilypond(filename)
            end
         else
            section.generate(opus_output)
         end
      end

   build_filename (a_name: ABSTRACT_STRING): STRING is
      do
         Result := a_name.out
         if current_section /= Void then
            current_section.filename_in(Result)
         end
         Result.append(once ".ly")
      end

feature {} -- System call to lilypond
   call_lilypond (filename: STRING) is
      require
         filename /= Void
         managed_output
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
   connect_to (a_output: like opus_output) is
      require
         a_output.is_connected
      do
         make
         managed_output := False
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
      end

   opus_name: FIXED_STRING
   opus_output: OUTPUT_STREAM
   managed_output: BOOLEAN
   instruments: LINKED_HASHED_DICTIONARY[MIXUP_LILYPOND_INSTRUMENT, FIXED_STRING]
   bar_number: INTEGER
   context: MIXUP_CONTEXT

   current_section: MIXUP_LILYPOND_SECTION

invariant
   instruments /= Void

end -- class MIXUP_LILYPOND_PLAYER
