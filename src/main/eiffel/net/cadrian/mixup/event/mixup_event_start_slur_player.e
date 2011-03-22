deferred class MIXUP_EVENT_START_SLUR_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_START_SLUR}
   play_start_slur (a_instrument: ABSTRACT_STRING; a_xuplet_numerator: INTEGER_64; a_xuplet_denominator: INTEGER_64
      a_text: ABSTRACT_STRING) is
      require
         a_instrument /= Void
         a_text /= Void
      deferred
      end

end -- class MIXUP_EVENT_START_SLUR_PLAYER