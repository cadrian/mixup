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
class MIXUP_MUSIXTEX_PLAYER

inherit
   MIXUP_PLAYER

create {ANY}
   make, connect_to

feature {ANY}
   name: FIXED_STRING
      once
         Result := "musixtex".intern
      end

   set_context (a_context: MIXUP_CONTEXT)
      do
      end

   native (a_def_source: MIXUP_SOURCE; a_context: MIXUP_NATIVE_CONTEXT; fn_name: STRING): MIXUP_VALUE
      do
         inspect
            fn_name
         when "current_bar_number" then
            create {MIXUP_VALUE_FACTORY} Result.make(a_context.call_source, agent (s: MIXUP_SOURCE; d: MIXUP_EVENT_DATA): INTEGER is do Result := d.bar_number end)
         else
            warning_at(a_source, "MusixTeX: unknown native function: " + fn_name)
         end
      end

feature {ANY}
   set_score (a_name: ABSTRACT_STRING)
      do
         push_section(a_name)
      end

   end_score
      do
         pop_section
      end

   set_book (a_name: ABSTRACT_STRING)
      do
         push_section(a_name)
      end

   end_book
      do
         pop_section
      end

   set_partitur (a_name: ABSTRACT_STRING)
      do
         push_section(a_name)
      end

   end_partitur
      do
         pop_section
      end

   set_instrument (a_name: ABSTRACT_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER])
      do
         instruments.put(create {MIXUP_MUSIXTEX_INSTRUMENT}.make(instruments.count + 1, a_name.intern), a_name.intern)
      end

   play_start_voices (a_data: MIXUP_EVENT_DATA; voice_ids: TRAVERSABLE[INTEGER])
      do
      end

   play_end_voices (a_data: MIXUP_EVENT_DATA)
      do
      end

   set_dynamics (a_data: MIXUP_EVENT_DATA; dynamics, position: ABSTRACT_STRING)
      do
      end

   set_note (a_data: MIXUP_EVENT_DATA; note: MIXUP_NOTE)
      do
      end

   next_bar (instrument, style: ABSTRACT_STRING)
      do
         if not playing then
            start_playing
         end
         bar_number := bar_number + 1
      end

   start_beam (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
      end

   end_beam (a_data: MIXUP_EVENT_DATA)
      do
      end

   start_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
      end

   end_slur (a_data: MIXUP_EVENT_DATA)
      do
      end

   start_phrasing_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
      end

   end_phrasing_slur (a_data: MIXUP_EVENT_DATA)
      do
      end

   start_repeat (a_data: MIXUP_EVENT_DATA; volte: INTEGER_64)
      do
      end

   end_repeat (a_data: MIXUP_EVENT_DATA)
      do
      end

feature {}
   put_header
      do
         output.put_string(once "[
                                 \input musixtex
                                 \input musixmad
                                 \startmuflex

                                 ]")
      end

   put_footer
      do
         output.put_string(once "[
                                 \endmuflex
                                 \end

                                 ]")
      end

   push_section (a_name: ABSTRACT_STRING)
      require
         a_name /= Void
      do
         if section_stack.is_empty then
            if output = Void then
               check
                  local_output
               end
               create {TEXT_FILE_WRITE} output.connect_to(a_name + ".tex")
            end
            put_header
         end
         section_stack.push(a_name.intern)
      end

   pop_section
      do
         if playing then
            stop_playing
         end
         section_stack.pop
         if section_stack.is_empty then
            put_footer
            if local_output then
               output.disconnect
               output := Void
            end
         end
      end

   start_playing
      require
         not playing
      do
         playing := True
         output.put_string(once "\instrumentnumber{")
         output.put_integer(instruments.count)
         output.put_line(once "}")
         instruments.do_all_items(agent {MIXUP_MUSIXTEX_INSTRUMENT}.emit_instrument(output))
         output.put_line(once "[
                               \generalmeter{\meterC}
                               \nostartrule
                               \startpiece

                               ]")
      ensure
         playing
      end

   stop_playing
      require
         playing
      do
         playing := False
         output.put_line(once "[
                               \endpiece

                               ]")
      ensure
         not playing
      end

   playing: BOOLEAN

feature {}
   connect_to (a_output: like output)
      require
         a_output.is_connected
      do
         make
         local_output := False
         output := a_output
      ensure
         output = a_output
         not local_output
      end

   make
      do
         local_output := True
         create section_stack.make
         create instruments.make
      end

   output: OUTPUT_STREAM
   local_output: BOOLEAN
   section_stack: STACK[FIXED_STRING]
   instruments: HASHED_DICTIONARY[MIXUP_MUSIXTEX_INSTRUMENT, FIXED_STRING]
   bar_number: INTEGER

invariant
   section_stack /= Void
   instruments /= Void

end -- class MIXUP_MUSIXTEX_PLAYER
