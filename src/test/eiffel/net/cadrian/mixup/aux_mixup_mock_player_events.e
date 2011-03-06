expanded class AUX_MIXUP_MOCK_PLAYER_EVENTS

feature {}
   set_score (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_score".intern, [name.intern])
      end

   end_score: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_score".intern, [])
      end

   set_book (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_book".intern, [name.intern])
      end

   end_book: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_book".intern, [])
      end

   set_partitur (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_partitur".intern, [name.intern])
      end

   end_partitur: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_partitur".intern, [])
      end

   set_instrument (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_instrument".intern, [name.intern])
      end

   set_dynamics (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; dynamics, position: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         pos: FIXED_STRING
      do
         if position /= Void then
            pos := position.intern
         end
         create Result.make("set_dynamics".intern, [instrument_name.intern, time_start, dynamics.intern, pos])
      end

   set_note (instrument: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_note".intern, [instrument.intern, time_start, note])
      end

   start_bar: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("start_bar".intern, [])
      end

   end_bar: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_bar".intern, [])
      end

end
