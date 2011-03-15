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

   fire_set_dynamics (instrument_name: ABSTRACT_STRING; dynamics, position: ABSTRACT_STRING) is
      deferred
      end

   fire_set_note (instrument_name: ABSTRACT_STRING; note: MIXUP_NOTE) is
      deferred
      end

   fire_next_bar (instrument_name: ABSTRACT_STRING) is
      deferred
      end

   fire_start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   fire_end_beam (instrument: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   fire_start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   fire_end_slur (instrument: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   fire_start_tie (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   fire_end_tie (instrument: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   fire_start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64) is
      require
         instrument /= Void
      deferred
      end

   fire_end_repeat (instrument: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

end
