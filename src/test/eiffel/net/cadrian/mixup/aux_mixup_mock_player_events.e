expanded class AUX_MIXUP_MOCK_PLAYER_EVENTS

feature {}
   set_score (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_score", [name])
      end

   end_score: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_score", [])
      end

   set_book (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_book", [name])
      end

   end_book: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_book", [])
      end

   set_partitur (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_partitur", [name])
      end

   end_partitur: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_partitur", [])
      end

   set_instrument (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_instrument", [name])
      end

   set_dynamics (instrument, dynamics, position: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_dynamics", [instrument, dynamics, position])
      end

   set_note (instrument: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_note", [instrument, time_start, note])
      end

   start_bar: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("start_bar", [])
      end

   end_bar: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_bar", [])
      end

end
