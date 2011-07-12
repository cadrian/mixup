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
class MIXUP_AGENT_EXECUTOR

inherit
   MIXUP_VALUE_VISITOR

insert
   MIXUP_ERRORS

create {ANY}
   map, reduce

feature {ANY}
   is_map: BOOLEAN is
      do
         Result := seed = Void
      end

   is_reduce: BOOLEAN is
      do
         Result := seed /= Void
      end

   call (a_commit_context: like commit_context): MIXUP_VALUE is
      require
         a_commit_context.context /= Void
         a_commit_context.player /= Void
      do
         commit_context := a_commit_context

         log.info.put_line("Executing " + mapper.out)

         concentrator := seed
         sequence.accept(Current)
         Result := concentrator
         check
            is_map implies Result = Void
         end

         commit_context.reset
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         from
            call_mapper(args(a_yield_iterator.value))
         until
            not a_yield_iterator.has_next
         loop
            a_yield_iterator.next(commit_context)
            call_mapper(args(a_yield_iterator.value))
         end
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT) is
      do
         call_mapper(args(a_agent))
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT) is
      do
         fatal("bad type")
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
         call_mapper(args(a_boolean))
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      do
         call_mapper(args(a_identifier))
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT) is
      do
         call_mapper(args(a_result))
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
         call_mapper(args(a_integer))
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
         call_mapper(args(a_real))
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
         call_mapper(args(a_string))
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE) is
      local
         i: INTEGER
      do
         from
            i := a_tuple.lower
         until
            i > a_tuple.upper
         loop
            call_mapper(args(a_tuple.item(i)))
            i := i + 1
         end
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST) is
      local
         i: INTEGER
      do
         from
            i := a_list.lower
         until
            i > a_list.upper
         loop
            call_mapper(args(a_list.item(i)))
            i := i + 1
         end
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ) is
      local
         i: INTEGER
      do
         from
            i := a_seq.lower
         until
            i > a_seq.upper
         loop
            call_mapper(args(a_seq.item(i)))
            i := i + 1
         end
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY) is
      local
         i: INTEGER
      do
         from
            i := a_dictionary.lower
         until
            i > a_dictionary.upper
         loop
            call_mapper(args2(a_dictionary.key(i), a_dictionary.item(i)))
            i := i + 1
         end
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      do
         call_mapper(args(a_function))
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
         call_mapper(args(a_function))
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION) is
      do
         call_mapper(args(a_function))
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         call_mapper(args(a_music))
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE) is
      do
         call_mapper(args(a_music))
      end

feature {}
   map (a_source: like source; a_sequence: like sequence; a_mapper: like mapper) is
      require
         a_source /= Void
         a_sequence /= Void
         a_mapper /= Void
         a_mapper.is_callable
      do
         source := a_source
         sequence := a_sequence
         mapper := a_mapper
      ensure
         is_map
         source = a_source
         sequence = a_sequence
         mapper = a_mapper
      end

   reduce (a_source: like source; a_sequence: like sequence; a_mapper: like mapper; a_seed: like seed) is
      require
         a_source /= Void
         a_sequence /= Void
         a_mapper /= Void
         a_mapper.is_callable
         a_seed /= Void
      do
         source := a_source
         sequence := a_sequence
         mapper := a_mapper
         seed := a_seed
      ensure
         is_reduce
         source = a_source
         sequence = a_sequence
         mapper = a_mapper
         seed = a_seed
      end

   args (a_value: MIXUP_VALUE): TRAVERSABLE[MIXUP_VALUE] is
      do
         if concentrator = Void then
            Result := {FAST_ARRAY[MIXUP_VALUE] << a_value >> }
         else
            Result := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_value >> }
         end
      end

   args2 (a_value1, a_value2: MIXUP_VALUE): TRAVERSABLE[MIXUP_VALUE] is
      do
         if concentrator = Void then
            Result := {FAST_ARRAY[MIXUP_VALUE] << a_value1, a_value2 >> }
         else
            Result := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_value1, a_value2 >> }
         end
      end

   call_mapper (a_args: TRAVERSABLE[MIXUP_VALUE]) is
      local
         value: MIXUP_VALUE
      do
         value := mapper.call(source, commit_context, a_args)
         if concentrator /= Void then
            concentrator := value
         end
      end

   commit_context: MIXUP_COMMIT_CONTEXT

   sequence: MIXUP_VALUE
   mapper: MIXUP_VALUE
   seed: MIXUP_VALUE

   concentrator: MIXUP_VALUE

invariant
   sequence /= Void
   mapper /= Void
   mapper.is_callable
   is_map xor is_reduce

end -- class MIXUP_AGENT_EXECUTOR
