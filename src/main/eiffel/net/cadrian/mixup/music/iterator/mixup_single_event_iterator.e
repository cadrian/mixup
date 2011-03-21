class MIXUP_SINGLE_EVENT_ITERATOR
--
-- Trivial iterator.
--

inherit
   MIXUP_EVENTS_ITERATOR

create {ANY}
   make

feature {ANY}
   start is
      do
      end

   is_off: BOOLEAN

   item: MIXUP_EVENT

   next is
      do
         is_off := True
      end

feature {}
   make (a_item: like item) is
      require
         a_item /= Void
      do
         item := a_item
      ensure
         item = a_item
         not is_off
      end

invariant
   item /= Void

end
