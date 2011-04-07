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
class AUX_MIXUP_MOCK_SOURCE

inherit
   MIXUP_SOURCE

create {ANY}
   make

feature {ANY}
   file: FIXED_STRING
   line: INTEGER
   column: INTEGER

   display (a_output: OUTPUT_STREAM) is
      do
      end

feature {}
   make is
      do
         file := "<test>".intern
      end

end -- class AUX_MIXUP_MOCK_EVENT
