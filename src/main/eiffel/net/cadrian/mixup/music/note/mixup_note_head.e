expanded class MIXUP_NOTE_HEAD

insert
   ANY
      redefine
         is_equal, out_in_tagged_out_memory
      end

feature {ANY}
   note: FIXED_STRING
   octave: INTEGER

   set (a_note: ABSTRACT_STRING; a_octave: INTEGER) is
      do
         note := a_note.intern
         octave := a_octave
      end

   relative (desc: FIXED_STRING): MIXUP_NOTE_HEAD is
      require
         desc /= Void
      local
         i, octave_shift, up_steps, down_steps, steps, a_steps: INTEGER
         note_: STRING
      do
         note_ := once ""
         note_.clear_count
         note_.append(desc)
         inspect
            note_.first
         when 'r', 'R' then
            Result.set(note_, 0)
         else
            if note_.first /= note.first then
               up_steps   := steps_to(note_.first, up_scale, 0)
               down_steps := steps_to(note_.first, down_scale, 0)

               if up_steps < down_steps then
                  steps := up_steps
                  a_steps := steps_to('a', up_scale, 1)
                  if a_steps <= steps then
                     octave_shift := octave_shift + 1
                  end
               else
                  steps := down_steps
                  a_steps := steps_to('a', down_scale, 0)
                  if a_steps < steps then
                     octave_shift := octave_shift - 1
                  end
               end
            end

            from
               i := note_.upper
            until
               i < note_.lower
            loop
               inspect
                  note_.item(i)
               when '%'' then
                  octave_shift := octave_shift + 1
                  note_.remove_last
               when ',' then
                  octave_shift := octave_shift - 1
                  note_.remove_last
               else
                  i := note_.lower
               end
               i := i - 1
            end

            Result.set(note_, octave + octave_shift)
         end
      end

   is_equal (other: like Current): BOOLEAN is
      do
         Result := note = other.note and then octave = other.octave
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(note)
         octave.append_in(tagged_out_memory)
      end

feature {}
   up_scale:   STRING is "abcdefgabcdefg"
   down_scale: STRING is "gfedcbagfedcba"

   steps_to (char: CHARACTER; scale: STRING; delta: INTEGER): INTEGER is
      local
         i, j: INTEGER
      do
         i := scale.first_index_of(note.first)
         j := scale.index_of(char, i + delta)
         Result := j - i
      end

end
