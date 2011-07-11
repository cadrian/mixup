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
class MIXUP_RESULT_ASSIGNMENT

inherit
   MIXUP_STATEMENT
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   expression: MIXUP_EXPRESSION

   call (a_commit_context: MIXUP_COMMIT_CONTEXT) is
      local
         value: MIXUP_VALUE
         context: MIXUP_USER_FUNCTION_CONTEXT
      do
         value := expression.eval(a_commit_context, True)
         if value = Void then
            error("value could not be computed")
         else
            context ::= a_commit_context.context
            context.set_result(value)
         end
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_result_assignment(Current)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "Result-assign: ")
         source.out_in_tagged_out_memory
      end

feature {}
   make (a_source: like source; a_expression: like expression) is
      require
         a_source /= Void
         a_expression /= Void
      do
         source := a_source
         expression := a_expression
      ensure
         source = a_source
         expression = a_expression
      end

invariant
   expression /= Void

end -- class MIXUP_RESULT_ASSIGNMENT
