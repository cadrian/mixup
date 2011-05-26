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
class TEST_NOTE_HEAD

insert
   EIFFELTEST_TOOLS

create {}
   make

feature {}
   source: AUX_MIXUP_MOCK_SOURCE

   make is
      do
         create source.make

         test_relative
         test_octave_shift
      end

   test_relative is
      local
         note, next: MIXUP_NOTE_HEAD
      do
         note.set(source, "a", 3)
         next := note.relative(source, (once "a").intern)
         assert(next.octave = 3)
         next := note.relative(source, (once "a'").intern)
         assert(next.octave = 4)
         next := note.relative(source, (once "a,").intern)
         assert(next.octave = 2)
         next := note.relative(source, (once "b").intern)
         assert(next.octave = 3)
         next := note.relative(source, (once "b'").intern)
         assert(next.octave = 4)
         next := note.relative(source, (once "f").intern)
         assert(next.octave = 2)
         next := note.relative(source, (once "f,").intern)
         assert(next.octave = 1)

         note.set(source, "c", 4)
         next := note.relative(source, (once "c").intern)
         assert(next.octave = 4)
         next := note.relative(source, (once "d").intern)
         assert(next.octave = 4)
         next := note.relative(source, (once "e").intern)
         assert(next.octave = 4)
         next := note.relative(source, (once "f").intern)
         assert(next.octave = 4)
         next := note.relative(source, (once "g").intern)
         assert(next.octave = 3)
         next := note.relative(source, (once "b").intern)
         assert(next.octave = 4)
         next := note.relative(source, (once "a").intern)
         assert(next.octave = 4)

         note.set(source, "e", 4)
         next := note.relative(source, (once "f").intern)
         assert(next.octave = 4)

         note.set(source, "f", 4)
         next := note.relative(source, (once "g").intern)
         assert(next.octave = 4)

         note.set(source, "g", 4)
         next := note.relative(source, (once "a").intern)
         assert(next.octave = 5)
      end

   test_octave_shift is
      local
         note, next: MIXUP_NOTE_HEAD
      do
         note.set(source, "a", 3)
         next.set(source, "a", 3)
         assert(note.octave_shift(next) = 0)
         next.set(source, "g", 2)
         assert(note.octave_shift(next) = 0)
         next.set(source, "f", 2)
         assert(note.octave_shift(next) = 0)
         next.set(source, "e", 2)
         assert(note.octave_shift(next) = 0)
         next.set(source, "d", 2)
         assert(note.octave_shift(next) = -1)
         next.set(source, "b", 3)
         assert(note.octave_shift(next) = 0)
         next.set(source, "c", 3)
         assert(note.octave_shift(next) = 0)
         next.set(source, "d", 3)
         assert(note.octave_shift(next) = 0)
         next.set(source, "e", 3)
         assert(note.octave_shift(next) = 1)
         next.set(source, "b", 4)
         assert(note.octave_shift(next) = 1)
         next.set(source, "e", 4)
         assert(note.octave_shift(next) = 2)
      end

end -- class TEST_NOTE_HEAD
