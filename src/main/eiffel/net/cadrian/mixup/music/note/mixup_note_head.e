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
expanded class MIXUP_NOTE_HEAD

insert
   MIXUP_ERRORS
      redefine
         is_equal, out_in_tagged_out_memory
      end

feature {ANY}
   note: FIXED_STRING
   octave: INTEGER

   set (a_source: like source; a_note: ABSTRACT_STRING; a_octave: INTEGER) is
      require
         a_source /= Void
      do
         source := a_source
         note := a_note.intern
         octave := a_octave
      end

   is_rest: BOOLEAN is
      do
         inspect
            note.first
         when 'r', 'R', 's' then
            Result := True
         else
         end
      end

   octave_shift (other: MIXUP_NOTE_HEAD): INTEGER is
         -- octave shift from Current to `other'
      do
         Result := other.octave - octave + octave_deviation(other.note, -1)
      end

   relative (a_source: like source; desc: FIXED_STRING): MIXUP_NOTE_HEAD is
      require
         not is_rest
         a_source /= Void
         desc /= Void
      local
         i, octave_shift_: INTEGER
         note_: STRING
      do
         note_ := once ""
         note_.clear_count
         note_.append(desc)
         inspect
            note_.first
         when 'r', 'R', 's' then
            Result.set(a_source, note_, 0)
         else
            octave_shift_ := octave_deviation(note_, 1)

            from
               i := note_.upper
            until
               i < note_.lower
            loop
               inspect
                  note_.item(i)
               when '%'' then
                  octave_shift_ := octave_shift_ + 1
                  note_.remove_last
               when ',' then
                  octave_shift_ := octave_shift_ - 1
                  note_.remove_last
               else
                  i := note_.lower
               end
               i := i - 1
            end

            Result.set(a_source, note_, octave + octave_shift_)
         end
      end

   is_equal (other: like Current): BOOLEAN is
      do
         Result := note = other.note and then octave = other.octave
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(note)
         inspect
            note.first
         when 'r', 'R', 's' then
         else
            octave.append_in(tagged_out_memory)
         end
      end

feature {}
   up_scale:   STRING is "abcdefgabcdefg"
   down_scale: STRING is "gfedcbagfedcba"

   steps_to (char: CHARACTER; scale: STRING; delta: INTEGER): INTEGER is
      local
         i, j: INTEGER
      do
         i := scale.first_index_of(note.first)
         if not scale.valid_index(i) then
            fatal("Not a note: '" + note.out + "'")
         end
         j := scale.index_of(char, i + delta)
         Result := j - i
      end

   octave_deviation (other_note: ABSTRACT_STRING; shift: INTEGER): INTEGER is
         -- octave shift from Current to `other'
      require
         other_note /= Void
         shift = 1 or else shift = -1
      local
         up_steps, down_steps, steps, a_steps: INTEGER
      do
         if other_note.first /= note.first then
            up_steps   := steps_to(other_note.first, up_scale, 0)
            down_steps := steps_to(other_note.first, down_scale, 0)

            if up_steps < down_steps then
               steps := up_steps
               a_steps := steps_to('a', up_scale, 1)
               if a_steps <= steps then
                  Result := shift
               end
            else
               steps := down_steps
               a_steps := steps_to('a', down_scale, 0)
               if a_steps < steps then
                  Result := -shift
               end
            end
         end
      ensure
         Result.in_range(-1, 1)
      end

end -- class MIXUP_NOTE_HEAD
