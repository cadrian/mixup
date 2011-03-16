class MIXUP_EVENT_START_TIE

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {ANY}
   instrument: FIXED_STRING

   xuplet_numerator: INTEGER_64

   xuplet_denominator: INTEGER_64

   text: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_START_TIE_PLAYER
      do
         p ::= player
         p.play_start_tie(instrument, xuplet_numerator, xuplet_denominator, text)
      end

feature {}
   make (a_instrument: ABSTRACT_STRING; a_xuplet_numerator: INTEGER_64; a_xuplet_denominator: INTEGER_64
      a_text: ABSTRACT_STRING) is
      require
         a_instrument /= Void
         a_text /= Void
      do
         instrument := a_instrument.intern
         xuplet_numerator := a_xuplet_numerator
         xuplet_denominator := a_xuplet_denominator
         text := a_text.intern
      ensure
         instrument = a_instrument
         xuplet_numerator = a_xuplet_numerator
         xuplet_denominator = a_xuplet_denominator
         text = a_text
      end

invariant
   instrument /= Void
   text /= Void

end -- class MIXUP_EVENT_START_TIE
