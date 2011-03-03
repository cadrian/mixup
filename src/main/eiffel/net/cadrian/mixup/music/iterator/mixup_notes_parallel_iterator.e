deferred class MIXUP_NOTES_PARALLEL_ITERATOR
--
-- Iterator on parallel music
--

inherit
   MIXUP_NOTES_ITERATOR

feature {ANY}
   start is
      do
         create {RING_ARRAY[MIXUP_NOTES_ITERATOR]} notes.with_capacity(0, count)
         add_notes_iterator
         sorter.sort(notes)
      end

   is_off: BOOLEAN is
      do
         Result := notes.is_empty
      end

   item: MIXUP_NOTES_ITERATOR_ITEM is
      do
         Result := notes.first.item
      end

   next is
      do
         notes.first.next
         if notes.first.is_off then
            notes.remove_first
         end
         sorter.sort(notes)
      end

feature {}
   notes:  COLLECTION[MIXUP_NOTES_ITERATOR]
   sorter: COLLECTION_SORTER[MIXUP_NOTES_ITERATOR]

   add_notes_iterator is
      require
         notes.is_empty
      deferred
      ensure
         not notes.is_empty
      end

   count: INTEGER is
      deferred
      ensure
         Result > 0
      end

end
