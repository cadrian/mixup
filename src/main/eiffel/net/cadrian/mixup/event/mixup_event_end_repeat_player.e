deferred class MIXUP_EVENT_END_REPEAT_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_END_REPEAT}
   play_end_repeat (a_instrument: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_END_REPEAT_PLAYER
