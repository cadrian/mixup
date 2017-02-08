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
class MIXUP_YIELD_ITERATOR

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   value: MIXUP_VALUE
      do
         Result := context.value
      end

   next (a_commit_context: MIXUP_COMMIT_CONTEXT)
      require
         has_next
         a_commit_context.context /= Void
         {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_commit_context.context
      do
         context.execute(a_commit_context)
         if context.yielded then
            source := context.yield_source
         end
      end

   has_next: BOOLEAN
      do
         Result := context.yielded
      end

   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_yield_iterator(Current)
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING)
      do
         a_name.append("<yield>")
      end

feature {}
   make (a_context: like context)
      require
         a_context.yielded
      do
         context := a_context
         source := a_context.yield_source
      ensure
         source = a_context.yield_source
         context = a_context
      end

   context: MIXUP_USER_FUNCTION_CONTEXT

   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      do
         Result := Current
      end

invariant
   context /= Void

end -- class MIXUP_YIELD_ITERATOR
