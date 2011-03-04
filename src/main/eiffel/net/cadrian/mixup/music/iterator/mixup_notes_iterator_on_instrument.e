class MIXUP_NOTES_ITERATOR_ON_INSTRUMENT
--
-- Iterator on a single instrument: will add lyrics
--

inherit
   MIXUP_NOTES_ITERATOR

create {MIXUP_INSTRUMENT}
   make

feature {ANY}
   start is
      do
         index := 0
         voices_iterator.start
      end

   is_off: BOOLEAN is
      do
         Result := voices_iterator.is_off
      end

   item: MIXUP_NOTES_ITERATOR_ITEM is
      local
         lyrics: MIXUP_LYRICS
         strophe: COLLECTION[FIXED_STRING]
         i: INTEGER
      do
         Result := voices_iterator.item
         create lyrics.make(strophes.count, Result.note)
         Result.set_note(lyrics)

         from
            i := strophes.lower
         until
            i > strophes.upper
         loop
            strophe := strophes.item(i)
            if index < strophe.count then
               lyrics.put(i - strophes.lower, strophe.item(index + strophe.lower))
            else
               lyrics.put(i - strophes.lower, once "")
            end
            i := i + 1
         end
      end

   next is
      do
         voices_iterator.next
         index := index + 1
      end

feature {}
   make (a_voices_iterator: like voices_iterator; a_strophes: like strophes) is
      require
         a_voices_iterator /= Void
         not a_strophes.is_empty
      do
         voices_iterator := a_voices_iterator
         strophes := a_strophes
         start
      ensure
         voices_iterator = a_voices_iterator
         strophes = a_strophes
      end

   voices_iterator: MIXUP_NOTES_ITERATOR
   strophes: COLLECTION[COLLECTION[FIXED_STRING]]
   index: INTEGER

invariant
   voices_iterator /= Void
   strophes /= Void

end
