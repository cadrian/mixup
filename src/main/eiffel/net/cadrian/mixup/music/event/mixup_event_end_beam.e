class MIXUP_EVENT_END_BEAM

inherit
   MIXUP_EVENT_WITHOUT_LYRICS

creation {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_END_BEAM_PLAYER
      do
         p ::= player
         p.play_end_beam(instrument)
      end

feature {}
   make (a_time: like time; a_instrument: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      do
         time := a_time
         instrument := a_instrument.intern
      ensure
         time = a_time
         instrument = a_instrument
      end

invariant
   instrument /= Void

end -- class MIXUP_EVENT_END_BEAM
