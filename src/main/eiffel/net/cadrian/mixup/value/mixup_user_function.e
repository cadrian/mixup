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

insert
   MIXUP_ERRORS

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
         context: MIXUP_USER_FUNCTION_CONTEXT
      do
         context := prepare(a_context, a_player, a_args)
         context.execute
         if context.yielded then
            create {MIXUP_YIELD_ITERATOR} Result.make(context)
         else
            Result := context.value
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

   prepare (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_USER_FUNCTION_CONTEXT is
      local
         args: HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]
         zip: ZIP[MIXUP_VALUE, FIXED_STRING]
      do
         if a_args.count /= signature.count then
            fatal("incorrect arguments number")
         else
            create args.with_capacity(signature.count)
            create zip.make(a_args, signature)
            zip.do_all(agent args.add)
            create Result.make(a_context, a_player, args)
            Result.add_statements(statements)
         end
      ensure
         Result /= Void
      end

invariant
   statements /= Void
   signature /= Void

end -- class MIXUP_USER_FUNCTION
