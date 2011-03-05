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
      end

end
