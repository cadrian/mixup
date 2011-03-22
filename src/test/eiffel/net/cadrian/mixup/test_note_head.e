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
class TEST_NOTE_HEAD

insert
   EIFFELTEST_TOOLS

create {}
   make

feature {}
   make is
      local
         note, next: MIXUP_NOTE_HEAD
      do
         note.set("a", 3)
         next := note.relative((once "a").intern)
         assert(next.octave = 3)
         next := note.relative((once "a'").intern)
         assert(next.octave = 4)
         next := note.relative((once "a,").intern)
         assert(next.octave = 2)
         next := note.relative((once "b").intern)
         assert(next.octave = 3)
         next := note.relative((once "b'").intern)
         assert(next.octave = 4)
         next := note.relative((once "f").intern)
         assert(next.octave = 2)
         next := note.relative((once "f,").intern)
         assert(next.octave = 1)

         note.set("c", 4)
         next := note.relative((once "c").intern)
         assert(next.octave = 4)
         next := note.relative((once "d").intern)
         assert(next.octave = 4)
         next := note.relative((once "e").intern)
         assert(next.octave = 4)
         next := note.relative((once "f").intern)
         assert(next.octave = 4)
         next := note.relative((once "g").intern)
         assert(next.octave = 3)
         next := note.relative((once "b").intern)
         assert(next.octave = 4)
         next := note.relative((once "a").intern)
         assert(next.octave = 4)

         note.set("e", 4)
         next := note.relative((once "f").intern)
         assert(next.octave = 4)

         note.set("f", 4)
         next := note.relative((once "g").intern)
         assert(next.octave = 4)

         note.set("g", 4)
         next := note.relative((once "a").intern)
         assert(next.octave = 5)
      end

end -- class TEST_NOTE_HEAD
