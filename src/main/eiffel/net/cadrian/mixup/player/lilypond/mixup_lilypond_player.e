class MIXUP_LILYPOND_PLAYER

inherit
   MIXUP_PLAYER

create {ANY}
   make, connect_to

feature {MIXUP_MIXER}
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

   set_instrument (name: ABSTRACT_STRING) is
      do
      end

   set_dynamics (instrument_name: ABSTRACT_STRING; dynamics, position: ABSTRACT_STRING) is
      do
      end

   set_note (instrument: ABSTRACT_STRING; note: MIXUP_NOTE) is
      do
      end

   next_bar (instrument, style: ABSTRACT_STRING) is
      do
      end

   start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_beam (instrument: ABSTRACT_STRING) is
      do
      end

   start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_slur (instrument: ABSTRACT_STRING) is
      do
      end

   start_tie (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_tie (instrument: ABSTRACT_STRING) is
      do
      end

   start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64) is
      do
      end

   end_repeat (instrument: ABSTRACT_STRING) is
      do
      end

feature {} -- headers and footers
   put_header is
      do
         section_output.put_line(once "%% ---------------- Generated using MiXuP ----------------")
      end

   put_footer is
      do
      end

feature {} -- section files management
   push_section (name: ABSTRACT_STRING) is
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
            put_header
         elseif managed_output then
            filename := opus_name.out + "-" + name.out
            create tfr.connect_to(filename)
            section_output.put_line("\include %"" + filename + "%"")
            outputs_stack.push(tfr)
         end
         section_stack.push(name.intern)
      end

   pop_section is
      do
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
   instruments: HASHED_DICTIONARY[MIXUP_LILYPOND_INSTRUMENT, FIXED_STRING]

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

end
