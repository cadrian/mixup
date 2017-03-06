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
class MIXUP_TRANSFORM_DEF

inherit
   MIXUP_TRANSFORM_CALL
      export {MIXUP_TRANSFORM_INTERPRETER}
         name
      end

insert
   LOGGING

create {MIXUP_TRANSFORM_INTERPRETER}
   make

feature {MIXUP_TRANSFORM_CALLS}
   item (a_target: MIXUP_TRANSFORM_VALUE; a_arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
      local
         v: MIXUP_TRANSFORM_VALUE; err: STRING
         fn_context: like context
      do
         if not is_function then
            err := "not a function"
         elseif a_arguments.count /= arguments.count then
            err := "arguments count mismatch"
         else
            fn_context := fill_context(a_target, a_arguments)
            caller.call([body, fn_context])
            v := fn_context.reference_at("result")
            if v = Void then
               err := "result not assigned"
            end
         end
         Result := [v, err]
      end

   call (a_target: MIXUP_TRANSFORM_VALUE; a_arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): ABSTRACT_STRING
      local
         fn_context: like context
      do
         if is_function then
            Result := "not a procedure"
         elseif a_arguments.count /= arguments.count then
            Result := "arguments count mismatch"
         else
            fn_context := fill_context(a_target, a_arguments)
            caller.call([body, fn_context])
         end
      end

feature {}
   fill_context (a_target: MIXUP_TRANSFORM_VALUE; a_arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]): like context
      local
         i: INTEGER
      do
         create Result
         if a_target /= Void then
            Result.add(a_target, "this")
         end
         from
            i := a_arguments.lower
         until
            i > a_arguments.upper
         loop
            Result.add(a_arguments.item(i), argument_names.item(i - a_arguments.lower + argument_names.lower))
            i := i + 1
         end
      end

feature {}
   make (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL; a_context: like context; a_caller: like caller)
      require
         a_node /= Void
         a_context /= Void
         a_caller /= Void
      local
         init: MIXUP_TRANSFORM_DEF_INITIALIZER
         a: FAST_ARRAY[MIXUP_TRANSFORM_TYPE]
      do
         create init.make(a_node)
         name := init.name
         argument_names := init.arguments
         create a.make(argument_names.count)
         a.set_all_with(type_unknown)
         arguments := a
         is_function := init.is_function
         if is_function then
            log.trace.put_line("defined #(1) as a function" # name)
         else
            log.trace.put_line("defined #(1) as a procedure" # name)
         end
         body := init.body
         context := a_context
         caller := a_caller
      ensure
         context = a_context
         caller = a_caller
      end

   context: HASHED_DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]
         -- parent context (not the one inside the function!)

   caller: PROCEDURE[TUPLE[MIXUP_TRANSFORM_NODE, HASHED_DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]]]
         -- callback into the interpreter; needs the def instructions
         -- and the function context (i.e. the one inside the
         -- function, not `context`)

   argument_names: TRAVERSABLE[STRING]
         -- the names of the arguments

   is_function: BOOLEAN
         -- True if the def is a function (i.e. there is some
         -- assignment to the "result" variable somewhere); False
         -- otherwise.

   body: MIXUP_TRANSFORM_NODE

invariant
   context /= Void
   caller /= Void
   body /= Void

end -- class MIXUP_TRANSFORM_DEF
