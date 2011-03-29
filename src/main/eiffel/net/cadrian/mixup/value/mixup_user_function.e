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
class MIXUP_USER_FUNCTION

inherit
   MIXUP_FUNCTION

create {ANY}
   make

feature {ANY}
   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_user_function(Current)
      end

   call (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         function_context: MIXUP_USER_FUNCTION_CONTEXT
         args: HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]
         zip: ZIP[MIXUP_VALUE, FIXED_STRING]
      do
         if a_args.count /= signature.count then
            not_yet_implemented -- error: incorrect arguments number
         else
            create function_context.make(once "<function>", a_context)
            create args.with_capacity(signature.count)
            create zip.make(a_args, signature)
            zip.do_all(agent args.add)
            statements.do_all(agent {MIXUP_STATEMENT}.call(function_context, a_player, args))
         end
      end

feature {}
   make (a_statements: like statements; a_signature: like signature) is
      require
         a_statements /= Void
         a_statements /= Void
      do
         statements := a_statements
         signature := a_signature
      ensure
         statements = a_statements
         signature = a_signature
      end

   statements: TRAVERSABLE[MIXUP_STATEMENT]
   signature: TRAVERSABLE[FIXED_STRING]

invariant
   statements /= Void
   signature /= Void

end -- class MIXUP_USER_FUNCTION
