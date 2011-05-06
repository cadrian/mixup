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
class TEST_LILYPOND_PLAYER

insert
   EIFFELTEST_TOOLS
   MIXUP_NOTE_DURATIONS
   MIXUP_MIXER
   LOGGING

create {}
   make

feature {}
   source: AUX_MIXUP_MOCK_SOURCE

   note (a_note: STRING; a_octave: INTEGER): MIXUP_NOTE_HEAD is
      do
         Result.set(source, a_note, a_octave)
      end

   make is
      local
         lilypond: MIXUP_LILYPOND_PLAYER
         buffer: STRING_OUTPUT_STREAM
         expected: STRING
         context: AUX_MIXUP_MOCK_CONTEXT
      do
         create source.make
         create buffer.make
         create lilypond.connect_to(buffer)
         create context.make(source, "test context", Void)
         lilypond.set_context(context)

         lilypond.play_set_partitur("test")
         lilypond.play_set_instrument("MyInstr")
         lilypond.play_set_note("MyInstr", {MIXUP_LYRICS {MIXUP_CHORD duration_4, source, << note("c", 4) >> }, source, << "doe", "do" >> });
         lilypond.play_end_partitur

         expected := "[
% ---------------- Generated using MiXuP ----------------

\include "mixup-partitur.ily"

\header {
   mixup-partitur = "test"
}

\book {
   \score {
      <<
         \new Staff = "MyInstr1" <<
            \set Staff.instrumentName = "MyInstr"
            \set Staff.shortInstrumentName = "M."
            \new Voice = "MyInstr1v1" {
               <<
                   c4
               >>
            }
            \new Lyrics = "MyInstr1v1x1" \lyricsto "MyInstr1v1" {
                "doe"
            }
            \new AltLyrics = "MyInstr1v1x2" \lyricsto "MyInstr1v1" {
                "do"
            }
         >>
      >>
   }
}

]"

         log.info.put_line(buffer.to_string)
         assert(buffer.to_string.is_equal(expected))
      end

end -- class TEST_LILYPOND_PLAYER
