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
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   identifier: MIXUP_IDENTIFIER
   expression: MIXUP_EXPRESSION

   call (a_commit_context: MIXUP_COMMIT_CONTEXT)
      local
         value: MIXUP_VALUE
      do
         value := expression.eval(a_commit_context, True)
         if value = Void then
            error("value could not be computed")
         else
            identifier.assign(a_commit_context, value, False, True, True)
         end
      end

   accept (visitor: VISITOR)
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_assignment(Current)
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "assign: ")
         source.out_in_tagged_out_memory
      end

feature {}
   make (a_source: like source; a_identifier: like identifier; a_expression: like expression)
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
