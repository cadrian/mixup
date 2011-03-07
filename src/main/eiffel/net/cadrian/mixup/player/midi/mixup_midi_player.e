class MIXUP_MUSIXTEX_MIDI

inherit
   MIXUP_PLAYER

create {ANY}
   make

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

   set_dynamics (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; dynamics, position: ABSTRACT_STRING) is
      do
      end

   set_note (instrument: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE) is
      do
      end

   start_bar is
      do
      end

   end_bar is
      do
      end

feature {}
   make is
      do
      end

end
