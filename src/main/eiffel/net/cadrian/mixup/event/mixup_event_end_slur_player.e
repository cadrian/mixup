deferred class MIXUP_EVENT_END_SLUR_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_END_SLUR}
   play_end_slur (a_instrument: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_END_SLUR_PLAYER
