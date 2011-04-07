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
   note (a_note: STRING; a_octave: INTEGER): MIXUP_NOTE_HEAD is
      do
         Result.set(a_note, a_octave)
      end

   make is
      local
         lilypond: MIXUP_LILYPOND_PLAYER
         buffer: STRING_OUTPUT_STREAM
         expected: STRING
         source: AUX_MIXUP_MOCK_SOURCE
      do
         create source.make
         create buffer.make
         create lilypond.connect_to(buffer)

         lilypond.set_partitur("test")
         lilypond.set_instrument("Instr")
         lilypond.set_note("Instr", {MIXUP_CHORD duration_4, source, << note("c", 4) >> });
         lilypond.end_partitur

         expected := "[
% ---------------- Generated using MiXuP ----------------

\include "mixup-partitur.ily"

\header {
   mixup-partitur = "test"
}

\book {
   \score {
      <<
         \new Staff = "Instr1" <<
            \set Staff.instrumentName = "Instr"
            \new Voice = "Instr1Voice1" {
               <<
                  c4
               >>
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
