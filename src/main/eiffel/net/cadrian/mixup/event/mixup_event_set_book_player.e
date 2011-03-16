deferred class MIXUP_EVENT_SET_BOOK_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_SET_BOOK}
   play_set_book (a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      deferred
      end

end -- class MIXUP_EVENT_SET_BOOK_PLAYER
