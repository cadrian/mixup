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
class MIXUP_MIDI_FILE_WRITE

inherit
   MIXUP_MIDI_OUTPUT_STREAM

create {ANY}
   make, connect_to

feature {ANY}
   connect_to (a_stream: BINARY_FILE_WRITE) is
      require
         a_stream.is_connected
         not is_connected
      do
         stream := a_stream
      ensure
         stream = a_stream
         is_connected
      end

   is_connected: BOOLEAN is
      do
         Result := stream /= Void and then stream.is_connected
      end

   disconnect is
      require
         is_connected
      do
         stream.disconnect
      end

feature {}
   make is
      do
      end

   put_integer_8 (byte: INTEGER_32) is
      do
         stream.put_byte(byte)
      end

   stream: BINARY_FILE_WRITE

end -- class MIXUP_MIDI_OUTPUT_STREAM
