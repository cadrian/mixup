class MIXUP_EVENT_NEXT_BAR

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {ANY}
   instrument: FIXED_STRING

   style: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_NEXT_BAR_PLAYER
      do
         p ::= player
         p.play_next_bar(instrument, style)
      end

feature {}
   make (a_instrument: ABSTRACT_STRING; a_style: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      do
         instrument := a_instrument.intern
         if a_style /= Void then
            style := a_style.intern
         end
      ensure
         instrument = a_instrument
         style = a_style
      end

invariant
   instrument /= Void

end -- class MIXUP_EVENT_NEXT_BAR
