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
class MIXUP_EQ

inherit
   MIXUP_COMPARISON_OPERATOR

create {ANY}
   make

feature {ANY}
   accept (visitor: VISITOR)
      local
         v: MIXUP_EXPRESSION_VISITOR
      do
         v ::= visitor
         v.visit_eq(Current)
      end

feature {}
   compute (left_val, right_val: MIXUP_VALUE): MIXUP_VALUE
      local
         left_value: COMPARABLE
      do
         left_val.accept(Current)
         left_value := value
         right_val.accept(Current)
         create {MIXUP_BOOLEAN} Result.make(source, left_value.is_equal(value))
      end

   operator: STRING is "="

end -- class MIXUP_EQ
