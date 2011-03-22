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
class MIXUP_CHORD

inherit
   MIXUP_NOTE
      redefine
         is_equal, out_in_tagged_out_memory
      end

create {ANY}
   make, manifest_create

feature {ANY}
   count: INTEGER is
      do
         Result := capacity
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

feature {}
   make (a_capacity: INTEGER; a_duration: INTEGER_64) is
      require
         a_duration > 0
         a_capacity > 0
      do
         manifest_make(a_capacity, a_duration)
      end

feature {} -- Manifest create:
   manifest_make (a_capacity: INTEGER; a_duration: INTEGER_64) is
      require
         a_capacity > 0
         a_duration > 0
      do
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
