deferred class MIXUP_EVENT_SET_PARTITUR_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_SET_PARTITUR}
   play_set_partitur (a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      deferred
      end

end -- class MIXUP_EVENT_SET_PARTITUR_PLAYER
