-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class TEST_MUSIXTEX_PLAYER

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
         musixtex: MIXUP_MUSIXTEX_PLAYER
         buffer: STRING_OUTPUT_STREAM
      do
         create buffer.make
         create musixtex.connect_to(buffer)

         musixtex.set_partitur("test")
         musixtex.set_instrument("Instr")
         musixtex.set_note("test", {MIXUP_CHORD duration_4, << note("c", 4) >> });
         musixtex.end_partitur

         -- \relativeaccid ???

         assert(buffer.to_string.is_equal("[
                                           \input musixtex
                                           \input musixmad
                                           \startmuflex
                                           \instrumentnumber{1}
                                           \setname{1}{Instr}
                                           \setstaffs{1}{1}
                                           \generalmeter{\meterC}
                                           \nostartrule
                                           \startpiece
                                           \NOtes\qa{j}\en
                                           \endpiece
                                           \endmuflex
                                           \end

                                           ]"))
      end

end -- class TEST_MUSIXTEX_PLAYER
