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
class MIXUP_MIDI_CONTROLLER_SWITCH

inherit
   MIXUP_MIDI_CONTROLLER_KNOB

create {ANY}
   make

feature {ANY}
   code: INTEGER_8

   valid_value (value: INTEGER): BOOLEAN is
      do
         Result := value.in_range(63, 64)
      end

   encode_to (message_code: INTEGER_8; value: INTEGER; stream: MIXUP_MIDI_OUTPUT_STREAM) is
      do
         stream.put_byte(message_code)
         stream.put_byte(code)
         stream.put_byte(value.to_integer_8)
      end

feature {}
   make (cod: INTEGER_8) is
      do
         code := cod
      ensure
         code = cod
      end

end -- class MIXUP_MIDI_CONTROLLER_SWITCH
