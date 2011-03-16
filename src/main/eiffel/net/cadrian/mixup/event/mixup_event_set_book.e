class MIXUP_EVENT_SET_BOOK

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {ANY}
   name: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_BOOK_PLAYER
      do
         p ::= player
         p.play_set_book(name)
      end

feature {}
   make (a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      do
         name := a_name.intern
      ensure
         name = a_name
      end

invariant
   name /= Void

end -- class MIXUP_EVENT_SET_BOOK
