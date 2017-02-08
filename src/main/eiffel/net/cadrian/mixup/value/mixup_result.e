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
class MIXUP_RESULT

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_result(Current)
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING)
      do
         a_name.append(once "Result")
      end

feature {}
   make (a_source: like source)
      require
         a_source /= Void
      do
         source := a_source
      ensure
         source = a_source
      end

   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      local
         user_function: MIXUP_USER_FUNCTION_CONTEXT
      do
         if not (user_function ?:= a_commit_context.context) then
            fatal("Result not in a function")
         end
         user_function ::= a_commit_context.context
         Result := user_function.value
      end

end -- class MIXUP_RESULT
