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
class MIXUP_INSPECT

inherit
   MIXUP_STATEMENT
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   call (a_context: MIXUP_USER_FUNCTION_CONTEXT) is
      local
         i: INTEGER; done: BOOLEAN; execution_context: MIXUP_INSPECT_EXECUTION
      do
         from
            i := branch_list.lower
            create execution_context.make(source, a_context, expression)
         until
            done or else i > branch_list.upper
         loop
            done := execution_context.match(branch_list.item(i))
            i := i + 1
         end
         if not done and then otherwise /= Void then
            a_context.add_statements(otherwise.statements)
         end
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_inspect(Current)
      end

   expression: MIXUP_EXPRESSION

   branches: TRAVERSABLE[MIXUP_INSPECT_BRANCH] is
      do
         Result := branch_list
      end

   otherwise: MIXUP_ELSE

   add_branch (a_branch: MIXUP_INSPECT_BRANCH) is
      require
         a_branch /= Void
      do
         branch_list.add_last(a_branch)
      ensure
         branches.count = old branches.count + 1
         branches.last = a_branch
      end

   set_otherwise (a_otherwise: like otherwise) is
      do
         otherwise := a_otherwise
      ensure
         otherwise = a_otherwise
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "inspect: ")
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
         create branch_list.with_capacity(1)
      ensure
         source = a_source
         expression = a_expression
      end

   branch_list: FAST_ARRAY[MIXUP_INSPECT_BRANCH]

invariant
   branch_list.for_all(agent (branch: MIXUP_INSPECT_BRANCH): BOOLEAN is do Result := branch /= Void end)

end -- class MIXUP_INSPECT
