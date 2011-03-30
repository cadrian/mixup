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
class MIXUP_IF_THEN_ELSE

inherit
   MIXUP_STATEMENT

create {ANY}
   make

feature {ANY}
   call (a_context: MIXUP_USER_FUNCTION_CONTEXT) is
      do
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_if_then_else(Current)
      end

   conditions: TRAVERSABLE[MIXUP_IF] is
      do
         Result := condition_list
      end

   otherwise: MIXUP_ELSE

   add_condition (a_condition: MIXUP_IF) is
      require
         a_condition /= Void
      do
         condition_list.add_last(a_condition)
      ensure
         conditions.count = old conditions.count + 1
         conditions.last = a_condition
      end

   set_otherwise (a_otherwise: like otherwise) is
      do
         otherwise := a_otherwise
      ensure
         otherwise = a_otherwise
      end

feature {}
   make is
      do
         create condition_list.with_capacity(1)
      end

   condition_list: FAST_ARRAY[MIXUP_IF]

invariant
   condition_list.for_all(agent (condition: MIXUP_IF): BOOLEAN is do Result := condition /= Void end)

end -- class MIXUP_IF_THEN_ELSE
