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
class MIXUP_MIDI_FILE_READ

inherit
   MIXUP_MIDI_INPUT_STREAM

create {ANY}
   make, connect_to

feature {ANY}
   connect_to (a_stream: like stream) is
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
      do
         stream.disconnect
         stream := Void
      end

   end_of_input: BOOLEAN is
      do
         Result := stream.end_of_input
      end

feature {}
   make is
      do
      end

   do_read_integer_8: INTEGER_32 is
      do
         stream.read_byte
         if stream.end_of_input then
            error := "Premature end of MIDI stream"
         else
            Result := stream.last_byte
         end
      end

   stream: BINARY_FILE_READ

end -- class MIXUP_MIDI_FILE_READ
