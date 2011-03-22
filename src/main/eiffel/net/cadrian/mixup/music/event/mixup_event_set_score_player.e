deferred class MIXUP_EVENT_SET_SCORE_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_SET_SCORE}
   play_set_score (a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      deferred
      end

end -- class MIXUP_EVENT_SET_SCORE_PLAYER
