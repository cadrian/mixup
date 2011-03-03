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
         next := note.relative("a")
         assert(next.octave = 3)
         next := note.relative("a'")
         assert(next.octave = 4)
         next := note.relative("a,")
         assert(next.octave = 2)
         next := note.relative("b")
         assert(next.octave = 3)
         next := note.relative("b'")
         assert(next.octave = 4)
         next := note.relative("f")
         assert(next.octave = 2)
         next := note.relative("f,")
         assert(next.octave = 1)

         note.set("c", 4)
         next := note.relative("c")
         assert(next.octave = 4)
         next := note.relative("d")
         assert(next.octave = 4)
         next := note.relative("e")
         assert(next.octave = 4)
         next := note.relative("f")
         assert(next.octave = 4)
         next := note.relative("g")
         assert(next.octave = 3)
         next := note.relative("b")
         assert(next.octave = 4)
         next := note.relative("a")
         assert(next.octave = 4)
      end

end
