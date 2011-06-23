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
class MIXUP_MUSIC_EVALUATOR
   --
   -- Evals a value and returns the music it contains, or fails.
   --

inherit
   MIXUP_VALUE_VISITOR
      redefine
         visit_no_value
      end

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): MIXUP_MUSIC is
      local
         value: MIXUP_VALUE
      do
         value := a_context.resolver.resolve(identifier, a_player)
         if value = Void then
            create {MIXUP_ZERO_MUSIC} Result.make(source)
         else
            music := Void
            value.accept(Current)
            Result := music
         end
      ensure
         Result /= Void
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT) is
      do
         fatal("an agent is not music!")
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT) is
      do
         fatal("an open argument is not music!")
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
         fatal("a boolean is not music!")
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      do
         fatal("unexpected identifier")
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT) is
      do
         fatal("unexpected Result")
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
         fatal("an integer is not music!")
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
         fatal("a real is not music!")
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
         fatal("a string is not music!")
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE) is
      do
         fatal("a tuple is not music!")
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST) is
      do
         fatal("a list is not music!")
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ) is
      do
         fatal("a sequence is not music!")
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY) is
      do
         fatal("a dictionary is not music!")
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      do
         fatal("unexpected native function")
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
         fatal("unexpected user function")
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION) is
      do
         fatal("unexpected agent function")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         music := a_music.value
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE) is
      do
         music := a_music
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         fatal("unexpected yield iterator")
      end

feature {MIXUP_NO_VALUE}
   visit_no_value (a_no_value: MIXUP_NO_VALUE) is
      do
         create {MIXUP_ZERO_MUSIC} music.make(source)
      end

feature {}
   make (a_source: like source; a_identifier: like identifier) is
      require
         a_source /= Void
         a_identifier /= Void
      do
         source := a_source
         identifier := a_identifier
      ensure
         source = a_source
         identifier = a_identifier
      end

   identifier: MIXUP_IDENTIFIER
   music: MIXUP_MUSIC

invariant
   source /= Void
   identifier /= Void

end -- class MIXUP_MUSIC_EVALUATOR
