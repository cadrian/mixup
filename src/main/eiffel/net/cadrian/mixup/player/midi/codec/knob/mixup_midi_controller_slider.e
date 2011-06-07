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
class MIXUP_MIDI_CONTROLLER_SLIDER

inherit
   MIXUP_MIDI_CONTROLLER_KNOB

create {ANY}
   make

feature {ANY}
   msb_code: INTEGER_8
   lsb_code: INTEGER_8

   encode_to (message_code: INTEGER_8; value: INTEGER; stream: MIXUP_MIDI_OUTPUT_STREAM) is
      do
         if value > 0x7f then
            stream.put_byte(message_code)
            stream.put_byte(lsb_code)
            stream.put_byte(((value |>> 7) & 0x0000007f).to_integer_8)
         end
         stream.put_byte(message_code)
         stream.put_byte(msb_code)
         stream.put_byte((value & 0x0000007f).to_integer_8)
      end

   valid_value (value: INTEGER): BOOLEAN is
      do
         if lsb_code = 0 then
            Result := value.in_range(0, 0x0000007f)
         else
            Result := value.in_range(0, 0x00003fff)
         end
      end

feature {}
   make (msb, lsb: INTEGER_8) is
      require
         lsb /= 0 implies lsb > msb
      do
         msb_code := msb
         lsb_code := lsb
      ensure
         msb_code = msb
         lsb_code = lsb
      end

invariant
   lsb_code /= 0 implies lsb_code > msb_code

end -- class MIXUP_MIDI_CONTROLLER_SLIDER
