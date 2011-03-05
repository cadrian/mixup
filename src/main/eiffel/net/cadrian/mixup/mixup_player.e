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

   set_dynamics (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; dynamics, position: ABSTRACT_STRING) is
      require
         instrument_name /= Void
      deferred
      end

   set_note (instrument: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE) is
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

end
