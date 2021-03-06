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
class MIXUP_RESOLVER

inherit
   MIXUP_VALUE_VISITOR

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   resolve (a_identifier: MIXUP_IDENTIFIER; a_commit_context: MIXUP_COMMIT_CONTEXT): MIXUP_VALUE
      local
         identifier: MIXUP_IDENTIFIER
      do
         check
            a_commit_context.context = context
         end
         commit_context := a_commit_context
         identifier := resolved_identifier(a_identifier)
         if identifier /= Void then
            if identifier.is_simple then
               Result := context.get_local(identifier.simple_name)
            end
            if Result = Void then
               Result := identifier.eval(a_commit_context, True)
            end
         end
      end

feature {MIXUP_RESOLVER}
   resolved_identifier (a_identifier: MIXUP_IDENTIFIER): MIXUP_IDENTIFIER
      local
         i: INTEGER
      do
         create Result.make(a_identifier.source)
         from
            i := a_identifier.parts.lower
         until
            i > a_identifier.parts.upper
         loop
            Result.add_identifier_part(a_identifier.parts.item(i).source, a_identifier.parts.item(i).name)
            if a_identifier.parts.item(i).args /= Void then
               Result.set_args(resolved_args(a_identifier.parts.item(i).args))
            end
            i := i + 1
         end
      end

feature {}
   resolved_args (args: TRAVERSABLE[MIXUP_EXPRESSION]): FAST_ARRAY[MIXUP_VALUE]
      require
         args /= Void
      local
         i: INTEGER; arg: MIXUP_VALUE
      do
         create Result.with_capacity(args.count)
         from
            i := args.lower
         until
            i > args.upper
         loop
            arg := args.item(i).eval(commit_context, True)
            if arg /= Void then
               arg.accept(Current)
            else
               create {MIXUP_NO_VALUE} value.make(args.item(i).source)
            end
            Result.add_last(value)
            i := i + 1
         end
      ensure
         Result.count = args.count
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR)
      do
         value := a_yield_iterator
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT)
      do
         value := a_agent
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT)
      do
         value := a_open_argument
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN)
      do
         value := a_boolean
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER)
      do
         value := resolve(a_identifier, commit_context)
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT)
      do
         sedb_breakpoint -- TODO
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER)
      do
         value := a_integer
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL)
      do
         value := a_real
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING)
      do
         value := a_string
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE)
      do
         value := a_tuple
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST)
      do
         value := a_list
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ)
      do
         value := a_seq
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY)
      do
         value := a_dictionary
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION)
      do
         value := a_function
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION)
      do
         value := a_function
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION)
      do
         value := a_function
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE)
      do
         value := a_music
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE)
      do
         value := a_music
      end

feature {}
   make (a_context: like context)
      require
         a_context /= Void
      do
         context := a_context
      ensure
         context = a_context
      end

   context: MIXUP_CONTEXT
   value: MIXUP_VALUE

   commit_context: MIXUP_COMMIT_CONTEXT

invariant
   context /= Void

end -- class MIXUP_RESOLVER
