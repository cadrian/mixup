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
class MIXUP_CHORD

inherit
   MIXUP_NOTE
      redefine
         is_equal, out_in_tagged_out_memory
      end
   INDEXABLE[MIXUP_NOTE_HEAD]
      redefine
         is_equal, out_in_tagged_out_memory
      end

create {ANY}
   make, manifest_creation

feature {ANY}
   count: INTEGER is
      do
         Result := capacity
      end

   is_empty: BOOLEAN is False

   lower: INTEGER is 0

   upper: INTEGER is
      do
         Result := count - 1
      end

   item (i: INTEGER): MIXUP_NOTE_HEAD is
      do
         Result := storage.item(i)
      end

   first: like item is
      do
         Result := storage.item(lower)
      end

   last: like item is
      do
         Result := storage.item(upper)
      end

   capacity: INTEGER
   duration: INTEGER_64

   is_equal (other: like Current): BOOLEAN is
      local
         i: INTEGER
      do
         Result := capacity = other.capacity
            and then duration = other.duration
         from
            i := 0
         until
            not Result or else i = capacity
         loop
            Result := storage.item(i).is_equal(other.storage.item(i))
            i := i + 1
         end
      end

   put (a_index: INTEGER; a_note_head: MIXUP_NOTE_HEAD) is
      require
         a_index.in_range(0, capacity - 1)
      do
         manifest_put(a_index, a_note_head)
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := storage.item(0)
      end

   out_in_tagged_out_memory is
      local
         i: INTEGER
      do
         tagged_out_memory.append(once "{MIXUP_CHORD ")
         duration.append_in(tagged_out_memory)
         tagged_out_memory.append(once " << ")
         from
            i := 0
         until
            i = capacity
         loop
            if i > 0 then
               tagged_out_memory.append(once ", ")
            end
            storage.item(i).out_in_tagged_out_memory
            i := i + 1
         end
         tagged_out_memory.append(once " >> }")
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_NOTE_VISITOR
      do
         v ::= visitor
         v.visit_chord(Current)
      end

   has, fast_has (element: like item): BOOLEAN is
      do
         Result := valid_index(first_index_of(element))
      end

   first_index_of, fast_first_index_of (element: like item): INTEGER is
      do
         Result := index_of(element, lower)
      end

   index_of, fast_index_of (element: like item; start_index: INTEGER): INTEGER is
      local
         i: INTEGER
      do
         from
            Result := -1
            i := start_index
         until
            Result /= -1 or else i > upper
         loop
            if storage.item(i) = element then
               Result := i
            end
            i := i + 1
         end
      end

   reverse_index_of, fast_reverse_index_of (element: like item; start_index: INTEGER): INTEGER is
      local
         i: INTEGER
      do
         from
            Result := -1
            i := start_index
         until
            Result /= -1 or else i < lower
         loop
            if storage.item(i) = element then
               Result := i
            end
            i := i - 1
         end
      end

   last_index_of, fast_last_index_of (element: like item): INTEGER is
      do
         Result := reverse_index_of(element, upper)
      end

feature {}
   make (a_source: like source; a_capacity: INTEGER; a_duration: INTEGER_64) is
      require
         a_source /= Void
         a_duration > 0
         a_capacity > 0
      do
         manifest_make(a_capacity, a_duration, a_source)
      end

feature {} -- Manifest create:
   manifest_make (a_capacity: INTEGER; a_duration: INTEGER_64; a_source: like source) is
      require
         a_source /= Void
         a_capacity > 0
         a_duration > 0
      do
         source := a_source
         capacity := a_capacity
         duration := a_duration
         storage := storage.calloc(a_capacity)
      end

   manifest_put (index: INTEGER; note: MIXUP_NOTE_HEAD) is
      do
         storage.put(note, index)
      end

   manifest_semicolon_check: BOOLEAN is False

feature {MIXUP_CHORD}
   storage: NATIVE_ARRAY[MIXUP_NOTE_HEAD]

end -- class MIXUP_CHORD
