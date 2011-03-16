class MIXUP_EVENT_END_BOOK

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_END_BOOK_PLAYER
      do
         p ::= player
         p.play_end_book
      end

feature {}
   make is
      do
      end

end -- class MIXUP_EVENT_END_BOOK
