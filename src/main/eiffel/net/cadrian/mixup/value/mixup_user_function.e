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
      redefine
         out_in_tagged_out_memory
      end

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

   call (a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         fn_context: MIXUP_USER_FUNCTION_CONTEXT
      do
         fn_context := prepare(a_player, a_args)
         fn_context.execute
         if fn_context.yielded then
            create {MIXUP_YIELD_ITERATOR} Result.make(source, fn_context) -- TODO: wrong! must get the yield instruction source!
         else
            Result := fn_context.value
         end
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "<user function>")
      end

feature {}
   make (a_source: like source; a_context: like context; a_statements: like statements; a_signature: like signature) is
      require
         a_source /= Void
         a_context /= Void
         a_statements /= Void
         a_statements /= Void
      do
         source := a_source
         context := a_context
         statements := a_statements
         signature := a_signature
      ensure
         source = a_source
         context = a_context
         statements = a_statements
         signature = a_signature
      end

   context: MIXUP_CONTEXT
   statements: TRAVERSABLE[MIXUP_STATEMENT]
   signature: TRAVERSABLE[FIXED_STRING]

   prepare (a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_USER_FUNCTION_CONTEXT is
      local
         args: DICTIONARY[MIXUP_VALUE, FIXED_STRING]
         zip: ZIP[MIXUP_VALUE, FIXED_STRING]
      do
         if a_args.count /= signature.count then
            fatal("incorrect arguments number")
         else
            if signature.count = 0 then
               create {ARRAY_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} args.with_capacity(0)
            else
               create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} args.with_capacity(signature.count)
               create zip.make(a_args, signature)
               zip.do_all(agent args.add)
            end
            create Result.make(source, context, a_player, args)
            Result.set_bar_number(context.bar_number)
            Result.add_statements(statements)
         end
      ensure
         Result /= Void
      end

invariant
   context /= Void
   statements /= Void
   signature /= Void

end -- class MIXUP_USER_FUNCTION
