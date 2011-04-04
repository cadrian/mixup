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
class MIXUP_INTEGER_MODULO

inherit
   MIXUP_NUMERIC_OPERATOR

create {ANY}
   make

feature {}
   compute (left_val, right_val: MIXUP_VALUE): MIXUP_VALUE is
      local
         op: MIXUP_INTEGER_REMAINDER
      do
         op ::= operations.item(left_val)
         Result := op.integer_modulo(left_val, right_val)
      end

   operator: STRING is "\\"

end -- class MIXUP_INTEGER_MODULO
