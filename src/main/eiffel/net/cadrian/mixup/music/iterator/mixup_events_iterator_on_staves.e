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
class MIXUP_EVENTS_ITERATOR_ON_STAVES
   --
   -- Iterator on parallel staves
   --

inherit
   MIXUP_EVENTS_PARALLEL_ITERATOR

create {MIXUP_INSTRUMENT}
   make

feature {}
   make (a_context: like context; a_staves: like staves)
      require
         a_staves /= Void
      do
         context := a_context
         staves := a_staves
         start
      ensure
         staves = a_staves
      end

   add_notes_iterator
      do
         staves.do_all(agent add_events_iterator)
      end

   add_events_iterator (a_staff: MIXUP_STAFF)
      do
         notes.add_last(a_staff.new_events_iterator(context))
      end

   count: INTEGER
      do
         Result := staves.count
      end

   staves: TRAVERSABLE[MIXUP_STAFF]
   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   start_time: INTEGER_64

invariant
   staves /= Void

end -- class MIXUP_EVENTS_ITERATOR_ON_STAVES
