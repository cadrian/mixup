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
class MIXUP_ARGUMENTS_MERGER

inherit
   MIXUP_VALUE_VISITOR

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   merge (call_args: like agent_args): TRAVERSABLE[MIXUP_VALUE]
      require
         call_args /= Void
      local
         agent_index, call_index: INTEGER
      do
         if agent_args.is_empty then
            Result := call_args -- no args, means that all arguments are open
         else
            from
               create resolved_args.with_capacity(agent_args.count)
               agent_index := agent_args.lower
               call_index := call_args.lower
               if call_args.valid_index(call_index) then
                  call_arg := call_args.item(call_index)
               else
                  call_arg := Void
               end
            until
               agent_index > agent_args.upper
            loop
               agent_arg := agent_args.item(agent_index)
               agent_arg.accept(Current)
               if resolved_args.last = call_arg then
                  call_index := call_index + 1
                  if call_args.valid_index(call_index) then
                     call_arg := call_args.item(call_index)
                  else
                     call_arg := Void
                  end
               end
               agent_index := agent_index + 1
            end
            Result := resolved_args
         end
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR)
      do
         add_arg(a_yield_iterator)
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT)
      do
         add_arg(a_agent)
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT)
      do
         if call_arg = Void then
            fatal("not enough actual arguments")
         else
            add_arg(call_arg)
         end
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN)
      do
         add_arg(a_boolean)
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER)
      do
         add_arg(a_identifier)
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT)
      do
         add_arg(a_result)
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER)
      do
         add_arg(a_integer)
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL)
      do
         add_arg(a_real)
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING)
      do
         add_arg(a_string)
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE)
      do
         a_tuple.do_all(agent add_arg)
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST)
      do
         add_arg(a_list)
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ)
      do
         add_arg(a_seq)
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY)
      do
         add_arg(a_dictionary)
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION)
      do
         add_arg(a_function)
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION)
      do
         add_arg(a_function)
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION)
      do
         add_arg(a_function)
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE)
      do
         add_arg(a_music)
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE)
      do
         add_arg(a_music)
      end

feature {}
   make (a_source: like source; a_agent_args: like agent_args)
      require
         a_source /= Void
         a_agent_args /= Void
      do
         source := a_source
         agent_args := a_agent_args
      ensure
         source = a_source
         agent_args = a_agent_args
      end

   add_arg (a_arg: MIXUP_VALUE)
      do
         resolved_args.add_last(a_arg)
      end

   agent_args: TRAVERSABLE[MIXUP_VALUE]

   agent_arg: MIXUP_VALUE
   call_arg: MIXUP_VALUE

   resolved_args: FAST_ARRAY[MIXUP_VALUE]

invariant
   agent_args /= Void

end -- class MIXUP_ARGUMENTS_MERGER
