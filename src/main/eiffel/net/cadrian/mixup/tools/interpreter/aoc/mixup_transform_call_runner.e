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
class MIXUP_TRANSFORM_CALL_RUNNER

inherit
   MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER

create {MIXUP_TRANSFORM_INTERPRETER}
   make

feature {ANY}
   count: INTEGER then arguments.count
      end

   capacity: INTEGER then arguments.capacity
      end

   item (i: INTEGER): MIXUP_TRANSFORM_VALUE
      require
         count = capacity
         i.in_range(1, count)
      do
         Result := arguments.item(count - i)
      ensure
         Result /= Void
      end

feature {MIXUP_TRANSFORM_INTERPRETER}
   run
      do
         -- TODO
         error := "not yet implemented"
      end

feature {MIXUP_TRANSFORM_INTERPRETER}
   add_first (value: MIXUP_TRANSFORM_VALUE)
      require
         count < capacity
         value /= Void
      do
         arguments.add_last(value)
      ensure
         count = old count + 1
         capacity = old capacity
      end

feature {}
   make (a_capacity: INTEGER)
      do
         create expression_string
         create arguments.with_capacity(a_capacity)
      end

   arguments: FAST_ARRAY[MIXUP_TRANSFORM_VALUE]
         -- BEWARE: stored in reverse order!

invariant
   arguments /= Void

end -- class MIXUP_TRANSFORM_CALL_RUNNER
