class MIXUP_BOOK

inherit
   MIXUP_CONTEXT

create {ANY}
   make

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.start_book(Current)
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.end_book(Current)
      end

end
