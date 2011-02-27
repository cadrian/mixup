expanded class AUX_MIXUP_MOCK_PLAYER_EVENTS

feature {}
   set_partitur (name: STRING): AUX_MIXUP_MOCK_EVENT is
      do
      end

   set_instrument (name: STRING): AUX_MIXUP_MOCK_EVENT is
      do
      end

   set_dynamics (instrument, dynamics, position: STRING): AUX_MIXUP_MOCK_EVENT is
      do
      end

   set_note (instrument: STRING; time_start, time_tactus: INTEGER; note: STRING; octave, duration: INTEGER): AUX_MIXUP_MOCK_EVENT is
      do
      end

   set_lyric (instrument: STRING; time_start, time_tactus: INTEGER; lyric: STRING): AUX_MIXUP_MOCK_EVENT is
      do
      end

   start_bar: AUX_MIXUP_MOCK_EVENT is
      do
      end

   end_bar: AUX_MIXUP_MOCK_EVENT is
      do
      end

   end_piece: AUX_MIXUP_MOCK_EVENT is
      do
      end

end
