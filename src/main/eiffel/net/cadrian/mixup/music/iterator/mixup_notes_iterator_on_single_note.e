class MIXUP_NOTES_ITERATOR_ON_SINGLE_NOTE
--
-- Trivial iterator.
--

inherit
   MIXUP_NOTES_ITERATOR

create {MIXUP_NOTE}
   make

feature {ANY}
   start is
      do
      end

   is_off: BOOLEAN

   item: MIXUP_NOTES_ITERATOR_ITEM

   next is
      do
         is_off := True
      end

feature {}
   make (a_note: MIXUP_NOTE) is
      require
         a_note /= Void
      do
         item.set(0, a_note)
      ensure
         item.time = 0
         item.note = a_note
         not is_off
      end

invariant
   item.time = 0
   item.note /= Void

end
