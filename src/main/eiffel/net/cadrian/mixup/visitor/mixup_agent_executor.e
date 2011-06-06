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
   make

feature {ANY}
   call (a_context: like context; a_player: like player): MIXUP_VALUE is
      require
         a_context /= Void
         a_player /= Void
      do
         context := a_context
         player := a_player

         log.info.put_line("Executing " + mapper.out)

         concentrator := seed
         sequence.accept(Current)
         Result := concentrator

         context := Void
         player := Void
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
      do
         from
            args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_yield_iterator.value >> }
            concentrator := mapper.call(source, player, args)
         until
            not a_yield_iterator.has_next
         loop
            a_yield_iterator.next
            args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_yield_iterator.value >> }
            concentrator := mapper.call(source, player, args)
         end
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT) is
      do
         fatal("bad type")
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT) is
      do
         fatal("bad type")
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
      do
         args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_boolean >> }
         concentrator := mapper.call(source, player, args)
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      do
         fatal("bad type")
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
      do
         args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_result >> }
         concentrator := mapper.call(source, player, args)
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
      do
         args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_integer >> }
         concentrator := mapper.call(source, player, args)
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
      do
         args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_real >> }
         concentrator := mapper.call(source, player, args)
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
      do
         args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_string >> }
         concentrator := mapper.call(source, player, args)
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
         i: INTEGER
      do
         from
            i := a_tuple.lower
         until
            i > a_tuple.upper
         loop
            args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_tuple.item(i) >> }
            concentrator := mapper.call(source, player, args)
            i := i + 1
         end
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
         i: INTEGER
      do
         from
            i := a_list.lower
         until
            i > a_list.upper
         loop
            args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_list.item(i) >> }
            concentrator := mapper.call(source, player, args)
            i := i + 1
         end
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
         i: INTEGER
      do
         from
            i := a_seq.lower
         until
            i > a_seq.upper
         loop
            args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_seq.item(i) >> }
            concentrator := mapper.call(source, player, args)
            i := i + 1
         end
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY) is
      local
         args: TRAVERSABLE[MIXUP_VALUE]
         i: INTEGER
      do
         from
            i := a_dictionary.lower
         until
            i > a_dictionary.upper
         loop
            args := {FAST_ARRAY[MIXUP_VALUE] << concentrator, a_dictionary.key(i), a_dictionary.item(i) >> }
            concentrator := mapper.call(source, player, args)
            i := i + 1
         end
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      do
         fatal("bad type")
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
         fatal("bad type")
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION) is
      do
         fatal("bad type")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         fatal("bad type")
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE) is
      do
         fatal("bad type")
      end

feature {}
   make (a_source: like source; a_sequence: like sequence; a_mapper: like mapper; a_seed: like seed) is
      require
         a_source /= Void
         a_sequence /= Void
         a_mapper /= Void
         a_seed /= Void
         a_mapper.is_callable
      do
         source := a_source
         sequence := a_sequence
         mapper := a_mapper
         seed := a_seed
      ensure
         source = a_source
         sequence = a_sequence
         mapper = a_mapper
         seed = a_seed
      end

   context: MIXUP_CONTEXT
   player: MIXUP_PLAYER

   sequence: MIXUP_VALUE
   mapper: MIXUP_VALUE
   seed: MIXUP_VALUE

   concentrator: MIXUP_VALUE

invariant
   sequence /= Void
   mapper /= Void
   seed /= Void
   mapper.is_callable


end -- class MIXUP_AGENT_EXECUTOR
