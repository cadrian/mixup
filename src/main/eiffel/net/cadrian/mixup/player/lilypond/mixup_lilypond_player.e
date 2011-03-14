class MIXUP_LILYPOND_PLAYER

inherit
   MIXUP_PLAYER

create {ANY}
   make, connect_to

feature {MIXUP_MIXER}
   set_score (name: ABSTRACT_STRING) is
      do
      end

   end_score is
      do
      end

   set_book (name: ABSTRACT_STRING) is
      do
      end

   end_book is
      do
      end

   set_partitur (name: ABSTRACT_STRING) is
      do
      end

   end_partitur is
      do
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

   start_bar is
      do
      end

   end_bar is
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
      end

   output: OUTPUT_STREAM
   local_output: BOOLEAN

end
