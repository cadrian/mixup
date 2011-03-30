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
class MIXUP_YIELD

inherit
   MIXUP_STATEMENT

create {ANY}
   make

feature {ANY}
   expression: MIXUP_EXPRESSION

   call (a_context: MIXUP_USER_FUNCTION_CONTEXT) is
      do
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_yield(Current)
      end

feature {}
   make (a_expression: like expression) is
      require
         a_expression /= Void
      do
         expression := a_expression
      ensure
         expression = a_expression
      end

invariant
   expression /= Void

end -- class MIXUP_YIELD
