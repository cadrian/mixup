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
deferred class MIXUP_LIST_NODE

inherit
   MIXUP_NODE
      undefine out_in_tagged_out_memory
      end

insert
   TRAVERSABLE[MIXUP_NODE]

feature {ANY}
   frozen new_iterator: ITERATOR[MIXUP_NODE]
      do
         check
            dont_use_this: False
         end
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
            Result := item(i).source_line
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
            Result := item(i).source_column
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
            Result := item(i).source_index
            i := i + 1
         end
      end

feature {MIXUP_GRAMMAR}
   add (a_child: like item)
      deferred
      ensure
         count = old count + 1
         first = a_child -- because the grammer is right-recursive the last child is added first
      end

end -- class MIXUP_LIST_NODE
