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
   TRAVERSABLE[MIXUP_SYLLABLE]
      redefine
         is_equal, out_in_tagged_out_memory
      end

create {ANY}
   make, manifest_creation

create {MIXUP_LYRICS}
   duplicate

feature {ANY}
   timing: MIXUP_MUSIC_TIMING is
      do
         Result := note.timing
      end

   count: INTEGER is
      do
         Result := capacity
      end

   valid_anchor: BOOLEAN is
      do
         Result := note.valid_anchor
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
            if storage.item(i).in_word then
               tagged_out_memory.append(once "-- ")
            end
            tagged_out_memory.extend('"')
            tagged_out_memory.append(storage.item(i).syllable)
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

   lower: INTEGER is 0

   upper: INTEGER is
      do
         Result := count - 1
      end

   item (index: INTEGER): MIXUP_SYLLABLE is
      do
         Result := storage.item(index)
      end

   first: MIXUP_SYLLABLE is
      do
         Result := storage.item(lower)
      end

   last: MIXUP_SYLLABLE is
      do
         Result := storage.item(upper)
      end

   new_iterator: ITERATOR[MIXUP_SYLLABLE] is
      do
         crash
      end

   is_empty: BOOLEAN is False

   can_have_lyrics: BOOLEAN is True

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like Current is
      local
         note_: like note
      do
         note_ := note.commit(a_context, a_player, a_start_bar_number)
         create Result.duplicate(source, note_, capacity, storage)
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         note.set_timing(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_note: MIXUP_NOTE; a_lyrics: TRAVERSABLE[MIXUP_SYLLABLE]) is
      require
         a_source /= Void
         not a_lyrics.is_empty
         a_lyrics.for_all(agent (s: MIXUP_SYLLABLE): BOOLEAN is do Result := s.syllable /= Void end)
      local
         i: INTEGER
      do
         manifest_make(a_lyrics.count, a_note, a_source)
         from
            i := 0
         until
            i = a_lyrics.count
         loop
            storage.put(a_lyrics.item(i), i + a_lyrics.lower)
            i := i + 1
         end
      end

   duplicate (a_source: like source; a_note: MIXUP_NOTE; a_capacity: INTEGER; a_storage: like storage) is
      do
         manifest_make(a_capacity, a_note, a_source)
         storage := a_storage
      end

feature {} -- Manifest create (for tests):
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
      local
         syl: MIXUP_SYLLABLE
      do
         syl.set(unknown_source, syllable.intern, False)
         storage.put(syl, index)
      end

   manifest_semicolon_check: BOOLEAN is False

   unknown_source: MIXUP_SOURCE is
      once
         create {MIXUP_SOURCE_UNKNOWN} Result
      end

feature {MIXUP_LYRICS}
   storage: NATIVE_ARRAY[MIXUP_SYLLABLE]

invariant
   note /= Void

end -- class MIXUP_LYRICS
