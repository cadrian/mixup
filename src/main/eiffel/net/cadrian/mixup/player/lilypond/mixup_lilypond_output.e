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
class MIXUP_LILYPOND_OUTPUT

inherit
   MIXUP_ABSTRACT_OUTPUT

create {ANY}
   make, connect_to

feature {ANY}
   stream: OUTPUT_STREAM

   connect_to (a_stream: like stream) is
      require
         not is_connected
         a_stream.is_connected
      do
         stream := a_stream
      ensure
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

feature {}
   make is
      do
      end

end -- class MIXUP_LILYPOND_OUTPUT
