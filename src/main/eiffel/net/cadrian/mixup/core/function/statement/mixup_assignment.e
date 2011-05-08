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
class MIXUP_ASSIGNMENT

inherit
   MIXUP_STATEMENT

create {ANY}
   make

feature {ANY}
   identifier: MIXUP_IDENTIFIER
   expression: MIXUP_EXPRESSION

   call (a_context: MIXUP_USER_FUNCTION_CONTEXT) is
      local
         value: MIXUP_VALUE
      do
         value := expression.eval(a_context, a_context.player)
         if value = Void then
            error("value could not be computed")
         else
            a_context.setup(identifier.as_name.intern, value, False, True, True)
         end
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_assignment(Current)
      end

feature {}
   make (a_source: like source; a_identifier: like identifier; a_expression: like expression) is
      require
         a_source /= Void
         a_identifier /= Void
         a_expression /= Void
      do
         source := a_source
         identifier := a_identifier
         expression := a_expression
      ensure
         source = a_source
         identifier = a_identifier
         expression = a_expression
      end

invariant
   identifier /= Void
   expression /= Void

end -- class MIXUP_ASSIGNMENT
