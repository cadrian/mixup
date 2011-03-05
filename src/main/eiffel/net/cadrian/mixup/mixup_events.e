deferred class MIXUP_EVENTS

feature {ANY}
   fire_set_book (book_name: ABSTRACT_STRING) is
      deferred
      end

   fire_end_book is
      deferred
      end

   fire_set_score (score_name: ABSTRACT_STRING) is
      deferred
      end

   fire_end_score is
      deferred
      end

   fire_set_partitur (partitur_name: ABSTRACT_STRING) is
      deferred
      end

   fire_end_partitur is
      deferred
      end

   fire_set_instrument (instrument_name: ABSTRACT_STRING) is
      deferred
      end

   fire_set_dynamics (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; dynamics, position: ABSTRACT_STRING) is
      deferred
      end

   fire_set_note (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE) is
      deferred
      end

   fire_start_bar is
      deferred
      end

   fire_end_bar is
      deferred
      end

end
