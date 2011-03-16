class MIXUP_EVENT_END_SLUR

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {ANY}
   instrument: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_END_SLUR_PLAYER
      do
         p ::= player
         p.play_end_slur(instrument)
      end

feature {}
   make (a_instrument: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      do
         instrument := a_instrument.intern
      ensure
         instrument = a_instrument
      end

invariant
   instrument /= Void

end -- class MIXUP_EVENT_END_SLUR
