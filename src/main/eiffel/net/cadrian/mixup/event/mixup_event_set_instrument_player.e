deferred class MIXUP_EVENT_SET_INSTRUMENT_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_SET_INSTRUMENT}
   play_set_instrument (a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      deferred
      end

end -- class MIXUP_EVENT_SET_INSTRUMENT_PLAYER
