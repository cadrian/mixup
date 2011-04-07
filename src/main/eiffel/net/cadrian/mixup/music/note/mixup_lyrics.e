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
class MIXUP_LYRICS

inherit
   MIXUP_NOTE
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

   duration: INTEGER_64 is
      do
         Result := note.duration
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := note.anchor
      end

   capacity: INTEGER
   note: MIXUP_NOTE

   is_equal (other: like Current): BOOLEAN is
      local
         i: INTEGER
      do
         Result := capacity = other.capacity
            and then note.is_equal(other.note)
         from
            i := 0
         until
            not Result or else i = capacity
         loop
            Result := storage.item(i).is_equal(other.storage.item(i))
            i := i + 1
         end
      end

   out_in_tagged_out_memory is
      local
         i: INTEGER
      do
         tagged_out_memory.append(once "{MIXUP_LYRICS ")
         note.out_in_tagged_out_memory
         tagged_out_memory.append(once " << ")
         from
            i := 0
         until
            i = capacity
         loop
            if i > 0 then
               tagged_out_memory.append(once ", ")
            end
            tagged_out_memory.extend('"')
            tagged_out_memory.append(storage.item(i))
            tagged_out_memory.extend('"')
            i := i + 1
         end
         tagged_out_memory.append(once " >> }")
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_NOTE_VISITOR
      do
         v ::= visitor
         v.visit_lyrics(Current)
      end

feature {}
   make (a_source: like source; a_note: MIXUP_NOTE; a_lyrics: TRAVERSABLE[ABSTRACT_STRING]) is
      require
         a_source /= Void
         not a_lyrics.is_empty
         a_lyrics.for_all(agent (s: ABSTRACT_STRING): BOOLEAN is do Result := s /= Void end)
      local
         i: INTEGER
      do
         manifest_make(a_lyrics.count, a_note, a_source)
         from
            i := 0
         until
            i = a_lyrics.count
         loop
            manifest_put(i, a_lyrics.item(i + a_lyrics.lower))
            i := i + 1
         end
      end

feature {} -- Manifest create:
   manifest_make (a_capacity: INTEGER; a_note: MIXUP_NOTE; a_source: like source) is
      require
         a_capacity > 0
         a_note /= Void
         a_source /= Void
      do
         source := a_source
         capacity := a_capacity
         note := a_note
         storage := storage.calloc(a_capacity)
      end

   manifest_put (index: INTEGER; syllable: ABSTRACT_STRING) is
      do
         storage.put(syllable.intern, index)
      end

   manifest_semicolon_check: BOOLEAN is False

feature {MIXUP_LYRICS}
   storage: NATIVE_ARRAY[FIXED_STRING]

invariant
   note /= Void

end -- class MIXUP_LYRICS
