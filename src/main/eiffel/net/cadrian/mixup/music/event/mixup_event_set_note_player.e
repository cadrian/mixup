deferred class MIXUP_EVENT_SET_NOTE_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_SET_NOTE}
   play_set_note (a_instrument: ABSTRACT_STRING; a_note: MIXUP_NOTE) is
      require
         a_instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_SET_NOTE_PLAYER
