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

   value: MIXUP_VALUE is
      do
         Result := context.value
      end

   next is
      require
         has_next
      do
         context.execute
      end

   has_next: BOOLEAN is
      do
         Result := context.yielded
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_yield_iterator(Current)
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append("<yield>")
      end

feature {}
   make (a_source: like source; a_context: like context) is
      require
         a_source /= Void
      do
         source := a_source
         context := a_context
      ensure
         source = a_source
         context = a_context
      end

   context: MIXUP_USER_FUNCTION_CONTEXT

   eval_ (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN; bar_number: INTEGER): MIXUP_VALUE is
      do
         Result := Current
      end

invariant
   context /= Void

end -- class MIXUP_YIELD_ITERATOR
