-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_EVENTS_ITERATOR_ON_INSTRUMENT
   --
   -- Iterator on a single instrument: will add lyrics
   --

inherit
   MIXUP_EVENTS_CACHED_ITERATOR

create {MIXUP_INSTRUMENT}
   make

feature {ANY}
   start is
      do
         index := 0
         voices_iterator.start
         item_memory := Void
      end

   is_off: BOOLEAN is
      do
         Result := voices_iterator.is_off
      end

feature {}
   fetch_item: MIXUP_EVENT is
      local
         lyrics: FAST_ARRAY[FIXED_STRING]
         strophe: COLLECTION[FIXED_STRING]
         i: INTEGER
      do
         Result := voices_iterator.item
         if Result.has_lyrics then
            create lyrics.with_capacity(strophes.count)
            from
               i := strophes.lower
            until
               i > strophes.upper
            loop
               strophe := strophes.item(i)
               if index < strophe.count then
                  lyrics.add_last(strophe.item(index + strophe.lower))
               else
                  lyrics.add_last((once "").intern)
               end
               i := i + 1
            end
            Result.set_lyrics(lyrics)
            used := True
         end
      end

   go_next is
      do
         voices_iterator.next
         if used then
            index := index + 1
            used := False
         end
      end

feature {}
   used: BOOLEAN

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

   voices_iterator: MIXUP_EVENTS_ITERATOR
   strophes: COLLECTION[COLLECTION[FIXED_STRING]]
   index: INTEGER

invariant
   voices_iterator /= Void
   strophes /= Void

end -- class MIXUP_EVENTS_ITERATOR_ON_INSTRUMENT
