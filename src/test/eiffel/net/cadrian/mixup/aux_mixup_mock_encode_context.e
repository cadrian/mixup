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
class AUX_MIXUP_MOCK_ENCODE_CONTEXT

inherit
   MIXUP_MIDI_ENCODE_CONTEXT

create {ANY}
   make

feature {ANY}
   transpose_half_tones: INTEGER_8

   set_transpose_half_tones (a_transpose_half_tones: like transpose_half_tones) is
      do
         transpose_half_tones := a_transpose_half_tones
      end

feature {}
   make is
      do
         create playing_notes.with_capacity(128)
      end

   playing_notes: HASHED_SET[INTEGER_8]

end -- class AUX_MIXUP_MOCK_ENCODE_CONTEXT
