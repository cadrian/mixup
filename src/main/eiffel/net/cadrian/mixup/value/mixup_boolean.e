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
class MIXUP_BOOLEAN

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: BOOLEAN

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_boolean(Current)
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         if value then
            a_name.append(once "True")
         else
            a_name.append(once "False")
         end
      end

feature {}
   make (a_value: like value) is
      do
         value := a_value
      ensure
         value = a_value
      end

end -- class MIXUP_BOOLEAN
