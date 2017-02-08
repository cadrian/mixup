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
class MIXUP_MIDI_TRANSPOSE

inherit
   MIXUP_EVENT_WITH_DATA
      rename
         make as make_
      redefine
         out_in_extra_data
      end
   MIXUP_EVENT_WITHOUT_LYRICS

create {MIXUP_MIDI_TRANSPOSE_FACTORY}
   make

feature {ANY}
   needs_instrument: BOOLEAN is True

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER)
      local
         p: MIXUP_MIDI_PLAYER
      do
         p ::= player
         p.play_transpose(data, half_tones)
      end

feature {}
   make (a_data: like data; a_half_tones: like half_tones)
      do
         make_(a_data)
         half_tones := a_half_tones
      ensure
         half_tones = a_half_tones
      end

   out_in_extra_data
      do
         tagged_out_memory.append(once ", half_tones=")
         half_tones.out_in_tagged_out_memory
      end

   half_tones: INTEGER_8

end -- class MIXUP_MIDI_TRANSPOSE
