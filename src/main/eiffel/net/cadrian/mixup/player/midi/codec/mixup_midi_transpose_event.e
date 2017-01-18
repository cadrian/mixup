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
class MIXUP_MIDI_TRANSPOSE_EVENT

inherit
   MIXUP_MIDI_CODEC

create {ANY}
   make

feature {ANY}
   byte_size: INTEGER is 0

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT) is
      do
         debug
            log.trace.put_line(once "transpose=" | &half_tones)
         end
         context.set_transpose_half_tones(half_tones)
      end

   half_tones: INTEGER_32

feature {}
   make (a_half_tones: like half_tones) is
      do
         half_tones := a_half_tones
      ensure
         half_tones = a_half_tones
      end

end -- class MIXUP_MIDI_EVENT
