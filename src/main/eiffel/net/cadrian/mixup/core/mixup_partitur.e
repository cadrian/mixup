class MIXUP_PARTITUR

inherit
   MIXUP_CONTEXT

create {ANY}
   make

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.start_partitur(Current)
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.end_partitur(Current)
      end

end
