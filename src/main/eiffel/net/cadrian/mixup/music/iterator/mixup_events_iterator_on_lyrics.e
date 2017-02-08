-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_EVENTS_ITERATOR_ON_LYRICS
   --
   -- Iterator on a single instrument: will add lyrics
   --

inherit
   MIXUP_EVENTS_CACHED_ITERATOR

create {MIXUP_INSTRUMENT}
   make

feature {ANY}
   start
      do
         index := 0
         voices_iterator.start
         item_memory := Void
      end

   is_off: BOOLEAN
      do
         Result := voices_iterator.is_off
      end

feature {}
   empty_syllable: MIXUP_SYLLABLE
      local
         unknown_source: MIXUP_SOURCE_UNKNOWN
      once
         create unknown_source
         Result.set(unknown_source, "".intern, False)
      end

   fetch_item: MIXUP_EVENT
      local
         lyrics: FAST_ARRAY[MIXUP_SYLLABLE]
         strophe: COLLECTION[MIXUP_SYLLABLE]
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
                  lyrics.add_last(empty_syllable)
               end
               i := i + 1
            end
            Result.set_lyrics(lyrics)
            used := True
         end
      end

   go_next
      do
         voices_iterator.next
         if used then
            index := index + 1
            used := False
         end
      end

feature {}
   used: BOOLEAN

   make (a_voices_iterator: like voices_iterator; a_strophes: like strophes)
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
   strophes: COLLECTION[COLLECTION[MIXUP_SYLLABLE]]
   index: INTEGER

invariant
   voices_iterator /= Void
   strophes /= Void

end -- class MIXUP_EVENTS_ITERATOR_ON_LYRICS
