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
class MIXUP_EVENTS_ITERATOR_ON_VOICE
   --
   -- Iterator on a single voice
   --

inherit
   MIXUP_EVENTS_CACHED_ITERATOR

create {MIXUP_VOICE}
   make

feature {ANY}
   start is
      do
         music_iterator := music.new_iterator
         iter_context := context
         music_duration := 0
         set_events_iterator
      end

   is_off: BOOLEAN is
      do
         Result := music_iterator.is_off and then events_iterator.is_off
      end

feature {}
   fetch_item: MIXUP_EVENT is
      do
         Result := events_iterator.item
      end

   go_next is
      do
         events_iterator.next
         if events_iterator.is_off then
            music_iterator.next
            if not music_iterator.is_off then
               set_events_iterator
            end
         end
      end

feature {MIXUP_VOICE}
   music_iterator: ITERATOR[MIXUP_MUSIC]
   events_iterator: MIXUP_EVENTS_ITERATOR
   music_duration: INTEGER_64

   set_events_iterator is
      do
         iter_context.add_time(music_duration)
         events_iterator := music_iterator.item.new_events_iterator(iter_context)
         music_duration := music_iterator.item.duration
      ensure
         events_iterator /= Void
      end

feature {}
   make (a_context: like context; a_music: like music) is
      require
         a_music /= Void
      do
         context := a_context
         music := a_music
         start
      ensure
         music = a_music
      end

   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   iter_context: MIXUP_EVENTS_ITERATOR_CONTEXT
   music: ITERABLE[MIXUP_MUSIC]

invariant
   music /= Void
   music_iterator /= Void

end -- class MIXUP_EVENTS_ITERATOR_ON_VOICE
