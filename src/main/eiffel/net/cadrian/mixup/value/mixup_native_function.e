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
class MIXUP_NATIVE_FUNCTION

inherit
   MIXUP_FUNCTION

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_native_function(Current)
      end

   call (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         Result := native_caller.item([a_context, a_player, a_args])
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_native_caller: like native_caller) is
      require
         a_source /= Void
         a_name /= Void
         a_native_caller /= Void
      do
         source := a_source
         name := a_name.intern
         native_caller := a_native_caller
      ensure
         source = a_source
         name = a_name.intern
         native_caller = a_native_caller
      end

   native_caller: FUNCTION[TUPLE[MIXUP_CONTEXT, MIXUP_PLAYER, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE]

invariant
   name /= Void
   native_caller /= Void

end -- class MIXUP_NATIVE_FUNCTION
