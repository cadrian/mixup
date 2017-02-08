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
         is_equal, out_in_tagged_out_memory, duration
      end
   INDEXABLE[MIXUP_NOTE_HEAD]
      redefine
         is_equal, out_in_tagged_out_memory
      end

create {ANY}
   make, manifest_creation

create {MIXUP_CHORD}
   duplicate

feature {ANY}
   timing: MIXUP_MUSIC_TIMING

   duration: INTEGER_64
      do
         Result := note_duration
      end

   count: INTEGER
      do
         Result := capacity
      end

   is_empty: BOOLEAN is False

   lower: INTEGER is 0

   upper: INTEGER
      do
         Result := count - 1
      end

   item (i: INTEGER): MIXUP_NOTE_HEAD
      do
         Result := storage.item(i)
      end

   first: like item
      do
         Result := storage.item(lower)
      end

   last: like item
      do
         Result := storage.item(upper)
      end

   capacity: INTEGER
   tie: BOOLEAN

   is_equal (other: like Current): BOOLEAN
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

   put (a_index: INTEGER; a_note_head: MIXUP_NOTE_HEAD)
      require
         a_index.in_range(0, capacity - 1)
      do
         manifest_put(a_index, a_note_head)
      end

   valid_anchor: BOOLEAN
      local
         i: INTEGER
      do
         from
         until
            Result or else i = capacity
         loop
            Result := not storage.item(i).is_rest
            i := i + 1
         end
      end

   anchor: MIXUP_NOTE_HEAD
      local
         i: INTEGER
      do
         from
            Result := storage.item(0)
            i := 1
         until
            not Result.is_rest or else i = capacity
         loop
            Result := storage.item(i)
            i := i + 1
         end
      end

   out_in_tagged_out_memory
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

   accept (visitor: VISITOR)
      local
         v: MIXUP_NOTE_VISITOR
      do
         v ::= visitor
         v.visit_chord(Current)
      end

   has, fast_has (element: like item): BOOLEAN
      do
         Result := valid_index(first_index_of(element))
      end

   first_index_of, fast_first_index_of (element: like item): INTEGER
      do
         Result := index_of(element, lower)
      end

   index_of, fast_index_of (element: like item; start_index: INTEGER): INTEGER
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

   reverse_index_of, fast_reverse_index_of (element: like item; start_index: INTEGER): INTEGER
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

   last_index_of, fast_last_index_of (element: like item): INTEGER
      do
         Result := reverse_index_of(element, upper)
      end

   can_have_lyrics: BOOLEAN
      local
         i: INTEGER
      do
         from
            i := lower
         until
            Result or else i > upper
         loop
            Result := not storage.item(i).is_rest
            i := i + 1
         end
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      do
         create Result.duplicate(source, capacity, storage, note_duration, tie)
         Result.set_timing(note_duration, a_commit_context.bar_number, 0)
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER)
      do
         timing := timing.set(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_capacity: INTEGER; a_duration: INTEGER_64; a_tie: like tie)
      require
         a_source /= Void
         a_duration > 0
         a_capacity > 0
      do
         manifest_make(a_capacity, a_duration, a_source)
         tie := a_tie
      ensure
         tie = a_tie
      end

   duplicate (a_source: like source; a_capacity: INTEGER; a_storage: like storage; a_duration: INTEGER_64; a_tie: like tie)
      do
         source := a_source
         capacity := a_capacity
         note_duration := a_duration
         storage := a_storage
         tie := a_tie
      end

   note_duration: INTEGER_64

feature {} -- Manifest create:
   manifest_make (a_capacity: INTEGER; a_duration: INTEGER_64; a_source: like source)
      require
         a_source /= Void
         a_capacity > 0
         a_duration > 0
      do
         source := a_source
         capacity := a_capacity
         note_duration := a_duration
         storage := storage.calloc(a_capacity)
      end

   manifest_put (index: INTEGER; note: MIXUP_NOTE_HEAD)
      do
         storage.put(note, index)
      end

   manifest_semicolon_check: BOOLEAN is False

feature {MIXUP_CHORD}
   storage: NATIVE_ARRAY[MIXUP_NOTE_HEAD]

invariant
   timing.is_set implies timing.duration = note_duration

end -- class MIXUP_CHORD
