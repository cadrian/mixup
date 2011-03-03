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
      require
         (once "abcdefgrR").has(a_note.first)
         a_note.count /= 1 implies (a_note.count = 3 and then a_note.last = 's' and then (once "ei").has(a_note.item(2)) and then not (once "rR").has(a_note.first))
      do
         note := a_note.intern
         octave := a_octave
      end

   relative (desc: STRING): MIXUP_NOTE_HEAD is
      require
         desc /= Void
      local
         n_index, a_index, octave_shift: INTEGER
         note_: STRING
      do
         note_ := once ""
         note_.copy(desc)
         inspect
            note_.first
         when 'r', 'R' then
            Result.set(note_, 0)
         else
            n_index := relative_positions.reference_at(note.first).first_index_of(note_.first)
            a_index := relative_positions.reference_at(note.first).first_index_of('a')

            if n_index = 4 or else n_index >= a_index then
               octave_shift := 0
            elseif n_index < 4 then
               octave_shift := -1
            else
               octave_shift := 1
            end

            inspect
               note_.last
            when '%'' then
               octave_shift := octave_shift + 1
               note_.remove_last
            when ',' then
               octave_shift := octave_shift - 1
               note_.remove_last
            else
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
   relative_positions: DICTIONARY[FIXED_STRING, CHARACTER] is
      once
         Result := {HASHED_DICTIONARY[FIXED_STRING, CHARACTER]
         <<
           "efgabcd".intern, 'a';
           "fgabcde".intern, 'b';
           "gabcdef".intern, 'c';
           "abcdefg".intern, 'd';
           "bcdefga".intern, 'e';
           "cdefgab".intern, 'f';
           "defgabc".intern, 'g';
           >>};
      end

end
