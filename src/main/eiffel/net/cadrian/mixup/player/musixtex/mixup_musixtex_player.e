class MIXUP_MUSIXTEX_PLAYER

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
         instruments.put(create {MIXUP_MUSIXTEX_INSTRUMENT}.make(instruments.count + 1, name.intern), name.intern)
      end

   set_dynamics (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; dynamics, position: ABSTRACT_STRING) is
      do
      end

   set_note (instrument: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE) is
      do
      end

   start_bar is
      do
         if not playing then
            start_playing
         else
         end
      end

   end_bar is
      do
      end

   start_beam (instrument: ABSTRACT_STRING; text: ABSTRACT_STRING) is
      do
      end

   end_beam (instrument: ABSTRACT_STRING) is
      do
      end

   start_slur (instrument: ABSTRACT_STRING; text: ABSTRACT_STRING) is
      do
      end

   end_slur (instrument: ABSTRACT_STRING) is
      do
      end

   start_tie (instrument: ABSTRACT_STRING; text: ABSTRACT_STRING) is
      do
      end

   end_tie (instrument: ABSTRACT_STRING) is
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
         instruments.do_all_items(agent {MIXUP_MUSIXTEX_INSTRUMENT}.set_instrument(output))
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

invariant
   section_stack /= Void
   instruments /= Void

end
