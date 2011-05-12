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
   set_context (a_context: MIXUP_CONTEXT) is
      do
      end

   native (a_source: MIXUP_SOURCE; name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         inspect
            name
         when "current_bar_number" then
            create {MIXUP_INTEGER} Result.make(bar_number)
         else
            warning_at(a_source, "MusixTeX: unknown native function: " + name)
         end
      end

feature {ANY}
   set_score (name: ABSTRACT_STRING) is
      do
         push_section(name)
      end

   end_score is
      do
         pop_section
      end

   set_book (name: ABSTRACT_STRING) is
      do
         push_section(name)
      end

   end_book is
      do
         pop_section
      end

   set_partitur (name: ABSTRACT_STRING) is
      do
         push_section(name)
      end

   end_partitur is
      do
         pop_section
      end

   set_instrument (name: ABSTRACT_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]) is
      do
         instruments.put(create {MIXUP_MUSIXTEX_INSTRUMENT}.make(instruments.count + 1, name.intern), name.intern)
      end

   set_dynamics (a_data: MIXUP_EVENT_DATA; dynamics, position: ABSTRACT_STRING) is
      do
      end

   set_note (a_data: MIXUP_EVENT_DATA; note: MIXUP_NOTE) is
      do
      end

   next_bar (instrument, style: ABSTRACT_STRING) is
      do
         if not playing then
            start_playing
         end
         bar_number := bar_number + 1
      end

   start_beam (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_beam (a_data: MIXUP_EVENT_DATA) is
      do
      end

   start_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_slur (a_data: MIXUP_EVENT_DATA) is
      do
      end

   start_phrasing_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_phrasing_slur (a_data: MIXUP_EVENT_DATA) is
      do
      end

   start_repeat (a_data: MIXUP_EVENT_DATA; volte: INTEGER_64) is
      do
      end

   end_repeat (a_data: MIXUP_EVENT_DATA) is
      do
      end

feature {}
   put_header is
      do
         output.put_string(once "[
                                 \input musixtex
                                 \input musixmad
                                 \startmuflex

                                 ]")
      end

   put_footer is
      do
         output.put_string(once "[
                                 \endmuflex
                                 \end

                                 ]")
      end

   push_section (name: ABSTRACT_STRING) is
      require
         name /= Void
      do
         if section_stack.is_empty then
            if output = Void then
               check
                  local_output
               end
               create {TEXT_FILE_WRITE} output.connect_to(name + ".tex")
            end
            put_header
         end
         section_stack.push(name.intern)
      end

   pop_section is
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

   start_playing is
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

   stop_playing is
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
   connect_to (a_output: like output) is
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

   make is
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
