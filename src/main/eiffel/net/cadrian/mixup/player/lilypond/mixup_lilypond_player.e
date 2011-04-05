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
   MIXUP_PLAYER

insert
   MIXUP_ERRORS

create {ANY}
   make, connect_to

feature {ANY}
   native (name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         inspect
            name
         when "current_bar_number" then
            create {MIXUP_INTEGER} Result.make(bar_number)
         else
            fatal("unknown native function: " + name)
         end
      end

feature {ANY}
   set_score (name: ABSTRACT_STRING) is
      do
         push_section(once "score", name)
      end

   end_score is
      do
         pop_section
      end

   set_book (name: ABSTRACT_STRING) is
      do
         push_section(once "book", name)
      end

   end_book is
      do
         pop_section
      end

   set_partitur (name: ABSTRACT_STRING) is
      do
         push_section(once "partitur", name)
      end

   end_partitur is
      do
         pop_section
      end

   set_instrument (name: ABSTRACT_STRING) is
      local
         inst_name: FIXED_STRING
         instrument: MIXUP_LILYPOND_INSTRUMENT
      do
         inst_name := name.intern
         create instrument.make(inst_name)
         instruments.add(instrument, inst_name)
         bar_number := 0
      end

   set_dynamics (instrument: ABSTRACT_STRING; dynamics, position: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).set_dynamics(dynamics, position)
      end

   set_note (instrument: ABSTRACT_STRING; note: MIXUP_NOTE) is
      do
         instruments.reference_at(instrument.intern).set_note(note)
      end

   next_bar (instrument: ABSTRACT_STRING; style: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).next_bar(style)
         bar_number := bar_number + 1
      end

   start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).start_beam(xuplet_numerator, xuplet_denominator, text)
      end

   end_beam (instrument: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).end_beam
      end

   start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).start_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_slur (instrument: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).end_slur
      end

   start_tie (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).start_tie(xuplet_numerator, xuplet_denominator, text)
      end

   end_tie (instrument: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).end_tie
      end

   start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64) is
      do
         instruments.reference_at(instrument.intern).start_repeat(volte)
      end

   end_repeat (instrument: ABSTRACT_STRING) is
      do
         instruments.reference_at(instrument.intern).end_repeat
      end

feature {} -- headers and footers
   put_header (section, name: ABSTRACT_STRING) is
      do
         section_output.put_line("%% ---------------- Generated using MiXuP ----------------")
         section_output.put_new_line
         section_output.put_line("\include %"mixup-" + section.out + ".ily%"")
         section_output.put_new_line
         section_output.put_line("\header {")
         section_output.put_line("   mixup-" + section.out + " = %"" + name.out + "%"")
         section_output.put_line("}")
         section_output.put_new_line
         section_output.put_line("\book {")
         section_output.put_line("   \score {")
         section_output.put_line("      <<")
      end

   put_footer is
      do
         section_output.put_line("      >>")
         section_output.put_line("   }")
         section_output.put_line("}")
      end

feature {} -- section files management
   push_section (section, name: ABSTRACT_STRING) is
      require
         name /= Void
      local
         filename: STRING
         tfr: TEXT_FILE_WRITE
      do
         if section_stack.is_empty then
            check
               opus_name = Void
            end
            opus_name := name.intern
            if managed_output then
               check
                  opus_output = Void
               end
               create tfr.connect_to(name + ".ly")
               outputs_stack.push(tfr)
               opus_output := tfr
            end
         elseif managed_output then
            filename := opus_name.out + "-" + name.out
            create tfr.connect_to(filename)
            section_output.put_line("\include %"" + filename + "%"")
            outputs_stack.push(tfr)
         end
         put_header(section, name)
         section_stack.push(name.intern)
      end

   pop_section is
      do
         instruments.new_iterator_on_items.do_all(agent {MIXUP_LILYPOND_INSTRUMENT}.generate(section_output))
         instruments.clear_count
         section_stack.pop
         if section_stack.is_empty then
            put_footer
            opus_name := Void
         end
         if managed_output then
            section_output.disconnect
            outputs_stack.pop
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
         create section_stack.make
         create outputs_stack.make
         create instruments.make
      ensure
         opus_output = Void
      end

   opus_name: FIXED_STRING
   opus_output: OUTPUT_STREAM
   managed_output: BOOLEAN
   section_stack: STACK[FIXED_STRING]
   outputs_stack: STACK[OUTPUT_STREAM]
   instruments: LINKED_HASHED_DICTIONARY[MIXUP_LILYPOND_INSTRUMENT, FIXED_STRING]
   bar_number: INTEGER

   section_output: OUTPUT_STREAM is
         -- the output file for the current section.
      do
         if outputs_stack.is_empty then
            Result := opus_output
         else
            Result := outputs_stack.top
         end
      end

invariant
   section_stack /= Void
   outputs_stack /= Void
   instruments /= Void
   managed_output implies (section_stack.count = outputs_stack.count)
   (not managed_output) implies outputs_stack.is_empty

end -- class MIXUP_LILYPOND_PLAYER
