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
deferred class MIXUP_EVENTS_PARALLEL_ITERATOR
   --
   -- Iterator on parallel music
   --

inherit
   MIXUP_EVENTS_CACHED_ITERATOR

feature {ANY}
   start is
      do
         create {RING_ARRAY[MIXUP_EVENTS_ITERATOR]} notes.with_capacity(0, count)
         add_notes_iterator
         sorter.sort(notes)
      end

   is_off: BOOLEAN is
      do
         Result := notes.is_empty
      end

feature {}
   fetch_item: MIXUP_EVENT is
      do
         Result := notes.first.item
      end

   go_next is
      do
         notes.first.next
         if notes.first.is_off then
            notes.remove_first
         end
         sorter.sort(notes)
      end

feature {}
   notes:  COLLECTION[MIXUP_EVENTS_ITERATOR]
   sorter: COLLECTION_SORTER[MIXUP_EVENTS_ITERATOR]

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

end -- class MIXUP_EVENTS_PARALLEL_ITERATOR
