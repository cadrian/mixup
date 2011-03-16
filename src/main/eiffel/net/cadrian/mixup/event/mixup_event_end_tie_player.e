deferred class MIXUP_EVENT_END_TIE_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_END_TIE}
   play_end_tie (a_instrument: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_END_TIE_PLAYER
