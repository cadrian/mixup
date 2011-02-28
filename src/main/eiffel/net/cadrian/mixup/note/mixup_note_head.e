expanded class MIXUP_NOTE_HEAD

insert
   ANY
      redefine
         is_equal, out_in_tagged_out_memory
      end

feature {ANY}
   note: FIXED_STRING
   octave: INTEGER

   set (a_note: STRING; a_octave: INTEGER) is
      require
         (once "abcdefg").has(a_note.first)
         a_note.count /= 1 implies (a_note.count = 3 and then a_note.last = 's' and then (once "ei").has(a_note.item(2)))
      do
         note := a_note.intern
         octave := a_octave
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

end
