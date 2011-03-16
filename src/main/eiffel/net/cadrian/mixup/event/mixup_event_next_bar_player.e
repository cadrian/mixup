deferred class MIXUP_EVENT_NEXT_BAR_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_NEXT_BAR}
   play_next_bar (a_instrument: ABSTRACT_STRING; a_style: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_NEXT_BAR_PLAYER
