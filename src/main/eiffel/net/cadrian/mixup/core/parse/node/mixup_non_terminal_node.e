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
deferred class MIXUP_NON_TERMINAL_NODE

inherit
   MIXUP_NODE

feature {ANY}
   name_at (index: INTEGER): FIXED_STRING
      require
         valid_index(index)
      deferred
      end

   node_at (index: INTEGER): MIXUP_NODE
      require
         valid_index(index)
      deferred
      end

   valid_index (index: INTEGER): BOOLEAN
      deferred
      ensure
         definition: Result = (index >= lower and then index <= upper)
      end

   lower: INTEGER
      deferred
      ensure
         Result >= 0
      end

   upper: INTEGER
      deferred
      ensure
         Result >= upper - 1
      end

   count: INTEGER
      deferred
      ensure
         definition: Result = upper - lower + 1
      end

   is_empty: BOOLEAN
      deferred
      ensure
         definition: Result = (count = 0)
      end

   source_line: INTEGER
      local
         i: INTEGER
      do
         from
            i := lower
         until
            Result > 0 or else i > upper
         loop
            Result := node_at(i).source_line
            i := i + 1
         end
      end

   source_column: INTEGER
      local
         i: INTEGER
      do
         from
            i := lower
         until
            Result > 0 or else i > upper
         loop
            Result := node_at(i).source_column
            i := i + 1
         end
      end

   source_index: INTEGER
      local
         i: INTEGER
      do
         from
            i := lower
         until
            Result > 0 or else i > upper
         loop
            Result := node_at(i).source_index
            i := i + 1
         end
      end

feature {MIXUP_GRAMMAR}
   set (index: INTEGER; node: MIXUP_NODE)
      require
         valid_index(index)
      deferred
      ensure
         node_at(index) = node
      end

end -- class MIXUP_NON_TERMINAL_NODE
