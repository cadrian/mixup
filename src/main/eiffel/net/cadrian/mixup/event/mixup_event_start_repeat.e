class MIXUP_EVENT_START_REPEAT

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {ANY}
   instrument: FIXED_STRING

   volte: INTEGER_64

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_START_REPEAT_PLAYER
      do
         p ::= player
         p.play_start_repeat(instrument, volte)
      end

feature {}
   make (a_instrument: ABSTRACT_STRING; a_volte: INTEGER_64) is
      require
         a_instrument /= Void
      do
         instrument := a_instrument.intern
         volte := a_volte
      ensure
         instrument = a_instrument
         volte = a_volte
      end

invariant
   instrument /= Void

end -- class MIXUP_EVENT_START_REPEAT
