class MIXUP_SCORE

inherit
   MIXUP_CONTEXT

create {ANY}
   make

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.start_score(Current)
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.end_score(Current)
      end

end
