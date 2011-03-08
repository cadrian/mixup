deferred class MIXUP_PLAYER

feature {MIXUP_MIXER}
   set_score (name: ABSTRACT_STRING) is
      require
         name /= Void
      deferred
      end

   end_score is
      deferred
      end

   set_book (name: ABSTRACT_STRING) is
      require
         name /= Void
      deferred
      end

   end_book is
      deferred
      end

   set_partitur (name: ABSTRACT_STRING) is
      require
         name /= Void
      deferred
      end

   end_partitur is
      deferred
      end

   set_instrument (name: ABSTRACT_STRING) is
      require
         name /= Void
      deferred
      end

   set_dynamics (instrument_name: ABSTRACT_STRING; dynamics, position: ABSTRACT_STRING) is
      require
         instrument_name /= Void
      deferred
      end

   set_note (instrument: ABSTRACT_STRING; note: MIXUP_NOTE) is
      require
         instrument /= Void
      deferred
      end

   start_bar is
      deferred
      end

   end_bar is
      deferred
      end

   start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   end_beam (instrument: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   end_slur (instrument: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   start_tie (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

   end_tie (instrument: ABSTRACT_STRING) is
      require
         instrument /= Void
      deferred
      end

end
