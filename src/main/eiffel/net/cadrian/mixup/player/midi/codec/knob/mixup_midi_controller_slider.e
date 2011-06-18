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
   name: FIXED_STRING
   msb_code: INTEGER_8
   lsb_code: INTEGER_8

   is_coarse: BOOLEAN is
      do
         Result := lsb_code = 0
      end

   is_fine: BOOLEAN is
      do
         Result := not is_coarse
      end

   byte_size: INTEGER is
      do
         if is_coarse then
            Result := 3
         else
            Result := 7
         end
      end

   encode_to (message_code: INTEGER_8; value: INTEGER; stream: MIXUP_MIDI_OUTPUT_STREAM) is
      do
         debug
            log.trace.put_line(name.out + "=" + value.out)
         end
         if is_coarse then
            stream.put_byte(message_code)
            stream.put_byte(msb_code)
            stream.put_byte((value & 0x0000007f).to_integer_8)
         else
            stream.put_byte(message_code)
            stream.put_byte(lsb_code)
            stream.put_byte((value & 0x0000007f).to_integer_8)
            stream.put_byte(0) -- at the same time
            stream.put_byte(message_code)
            stream.put_byte(msb_code)
            stream.put_byte(((value |>> 7) & 0x0000007f).to_integer_8)
         end
      end

   valid_value (value: INTEGER): BOOLEAN is
      do
         if is_coarse then
            Result := value.in_range(0, 0x0000007f)
         else
            Result := value.in_range(0, 0x00003fff)
         end
      end

feature {}
   make (msb, lsb: INTEGER_8; a_name: ABSTRACT_STRING) is
      require
         lsb /= 0 implies lsb > msb
         a_name /= Void
      do
         msb_code := msb
         lsb_code := lsb
         name := a_name.intern
      ensure
         msb_code = msb
         lsb_code = lsb
         name = a_name.intern
      end

invariant
   lsb_code /= 0 implies lsb_code > msb_code

end -- class MIXUP_MIDI_CONTROLLER_SLIDER
