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
deferred class MIXUP_MIDI_CODEC

feature {ANY}
   byte_size: INTEGER is
      deferred
      ensure
         Result > 0
      end

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM) is
      require
         stream.is_connected
      deferred
      end

   byte_size_variable (variable: INTEGER_64): INTEGER is
      do
         inspect
            variable
         when 0..0x000000000000007f then
            Result := 1
         when 0x0000000000000080..0x0000000000003fff then
            Result := 2

         -- are the values below really used?

         when 0x0000000000004000..0x00000000001fffff then
            Result := 3
         else
            Result := 4
         end
      end

end -- class MIXUP_MIDI_CODEC
