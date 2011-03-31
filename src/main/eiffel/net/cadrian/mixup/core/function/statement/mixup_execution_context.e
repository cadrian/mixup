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
deferred class MIXUP_EXECUTION_CONTEXT

inherit
   MIXUP_VALUE_VISITOR

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      local
         value: MIXUP_VALUE
      do
         value := context.resolver.resolve(a_identifier, context.player)
         if value = Void then
            not_yet_implemented -- error: value could not be computed
         else
            value.accept(Current)
         end
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      do
         call_function(a_function)
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
         call_function(a_function)
      end

feature {}
   call_function (a_function: MIXUP_FUNCTION) is
      local
         value: MIXUP_VALUE
      do
         value := a_function.call(context, context.player, create {FAST_ARRAY[MIXUP_VALUE]}.make(0))
         if value = Void then
            not_yet_implemented -- error: could not compute value
         else
            value.accept(Current)
         end
      end

   context: MIXUP_USER_FUNCTION_CONTEXT

invariant
   context /= Void

end -- class MIXUP_EXECUTION_CONTEXT
