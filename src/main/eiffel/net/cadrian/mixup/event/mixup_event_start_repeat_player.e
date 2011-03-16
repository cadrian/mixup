deferred class MIXUP_EVENT_START_REPEAT_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_START_REPEAT}
   play_start_repeat (a_instrument: ABSTRACT_STRING; a_volte: INTEGER_64) is
      require
         a_instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_START_REPEAT_PLAYER
