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

   map (staff: INTEGER; voices: TRAVERSABLE[INTEGER]): MAP[TRAVERSABLE[INTEGER], INTEGER] is
      local
         ids: AVL_DICTIONARY[TRAVERSABLE[INTEGER], INTEGER]
      do
         create ids.make
         ids.add(create {AVL_SET[INTEGER]}.from_collection(voices), staff)
         Result := ids
      end

   event_data (instr: STRING; time: INTEGER_64; staff_id, voice_id: INTEGER): MIXUP_EVENT_DATA is
      do
         Result.set(source, time, instr.intern, staff_id, voice_id)
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
         lilypond.play_set_instrument("MyInstr", map(1, 1|..|1))
         lilypond.play_set_note(event_data("MyInstr",          0, 1, 1), {MIXUP_LYRICS {MIXUP_CHORD duration_4, source, << note("c", 4) >> }, source, << "doe", "do" >> });
         lilypond.play_set_note(event_data("MyInstr", duration_4, 1, 1), {MIXUP_LYRICS {MIXUP_CHORD duration_4, source, << note("d", 4) >> }, source, << "ray", "re" >> });
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
                   c4 d4
               >>
            }
            \new Lyrics = "MyInstr1v1x1" \lyricsto "MyInstr1v1" {
                "doe" "ray"
            }
            \new AltLyrics = "MyInstr1v1x2" \lyricsto "MyInstr1v1" {
                "do" "re"
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
