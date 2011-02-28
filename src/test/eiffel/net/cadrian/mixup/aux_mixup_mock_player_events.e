expanded class AUX_MIXUP_MOCK_PLAYER_EVENTS

feature {}
   set_score (name: STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_score", [name])
      end

   end_score: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_score", [])
      end

   set_book (name: STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_book", [name])
      end

   end_book: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_book", [])
      end

   set_partitur (name: STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_partitur", [name])
      end

   end_partitur: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_partitur", [])
      end

   set_instrument (name: STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_instrument", [name])
      end

   set_dynamics (instrument, dynamics, position: STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_dynamics", [instrument, dynamics, position])
      end

   set_note (instrument: STRING; time_start, time_tactus: INTEGER; note: MIXUP_NOTE): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_note", [instrument, time_start, time_tactus, note])
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
