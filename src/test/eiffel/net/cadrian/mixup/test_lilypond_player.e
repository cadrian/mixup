class TEST_LILYPOND_PLAYER

insert
   EIFFELTEST_TOOLS
   MIXUP_NOTE_DURATIONS
   MIXUP_MIXER

create {}
   make

feature {}
   note (a_note: STRING; a_octave: INTEGER): MIXUP_NOTE_HEAD is
      do
         Result.set(a_note, a_octave)
      end

   make is
      local
         lilypond: MIXUP_LILYPOND_PLAYER
         buffer: STRING_OUTPUT_STREAM
      do
         create buffer.make
         create lilypond.connect_to(buffer)

         lilypond.set_partitur("test")
         lilypond.set_instrument("Instr")
         lilypond.set_note("test", {MIXUP_CHORD duration_4, << note("c", 4) >> });
         lilypond.end_partitur

         assert(buffer.to_string.is_equal("[

                                           ]"))
      end

end
