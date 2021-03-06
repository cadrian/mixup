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
   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_user_function(Current)
      end

   call (a_source: MIXUP_SOURCE; a_commit_context: MIXUP_COMMIT_CONTEXT; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE
      local
         fn_context: MIXUP_USER_FUNCTION_CONTEXT
      do
         fn_context := prepare(a_source, a_commit_context, a_args)
         fn_context.execute(a_commit_context)
         if fn_context.yielded then
            create {MIXUP_YIELD_ITERATOR} Result.make(fn_context)
         else
            Result := fn_context.value
         end
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "<user function>")
      end

feature {}
   make (a_source: like source; a_definition_context: like definition_context; a_statements: like statements; a_signature: like signature)
      require
         a_source /= Void
         a_definition_context /= Void
         a_statements /= Void
         a_statements /= Void
      do
         source := a_source
         definition_context := a_definition_context
         statements := a_statements
         signature := a_signature
      ensure
         source = a_source
         definition_context = a_definition_context
         statements = a_statements
         signature = a_signature
      end

   definition_context: MIXUP_CONTEXT
   statements: TRAVERSABLE[MIXUP_STATEMENT]
   signature: TRAVERSABLE[FIXED_STRING]

   prepare (a_source: like source; a_commit_context: MIXUP_COMMIT_CONTEXT; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_USER_FUNCTION_CONTEXT
      require
         a_commit_context.context /= Void
      local
         args: DICTIONARY[MIXUP_VALUE, FIXED_STRING]
         zip: ZIP[MIXUP_VALUE, FIXED_STRING]
      do
         if a_args.count /= signature.count then
            fatal_at(a_source, "incorrect arguments number")
         else
            if signature.count = 0 then
               create {ARRAY_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} args.with_capacity(0)
            else
               create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} args.with_capacity(signature.count)
               create zip.make(a_args, signature)
               zip.do_all(agent args.add)
            end
            create Result.make(source, definition_context, args)
            Result := Result.commit(a_commit_context)
            Result.add_statements(statements)
         end
      ensure
         Result /= Void
      end

invariant
   definition_context /= Void
   statements /= Void
   signature /= Void

end -- class MIXUP_USER_FUNCTION
