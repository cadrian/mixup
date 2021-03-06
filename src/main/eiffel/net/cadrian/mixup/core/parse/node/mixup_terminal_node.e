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
deferred class MIXUP_TERMINAL_NODE

inherit
   MIXUP_NODE

feature {ANY}
   image: MIXUP_IMAGE
      deferred
      end

   source_line: INTEGER
      do
         Result := image.line
      end

   source_column: INTEGER
      do
         Result := image.column
      end

   source_index: INTEGER
      do
         Result := image.index
      end

end -- class MIXUP_TERMINAL_NODE
