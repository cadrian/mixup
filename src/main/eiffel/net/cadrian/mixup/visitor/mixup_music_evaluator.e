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
   eval (a_commit_context: MIXUP_COMMIT_CONTEXT; a_value: MIXUP_VALUE): MIXUP_MUSIC
      require
         a_value /= Void
      local
         old_music: like music
      do
         old_music := music
         music := Void
         a_value.accept(Current)
         Result := music.commit(a_commit_context)
         music := old_music
      ensure
         Result /= Void
         Result.timing.is_set
         music = old music
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT)
      do
         fatal("an agent is not music!")
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT)
      do
         fatal("an open argument is not music!")
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN)
      do
         fatal("a boolean is not music!")
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER)
      do
         fatal("unexpected identifier")
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT)
      do
         fatal("unexpected Result")
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER)
      do
         fatal("an integer is not music!")
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL)
      do
         fatal("a real is not music!")
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING)
      do
         fatal("a string is not music!")
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE)
      do
         fatal("a tuple is not music!")
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST)
      do
         fatal("a list is not music!")
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ)
      do
         fatal("a sequence is not music!")
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY)
      do
         fatal("a dictionary is not music!")
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION)
      do
         fatal("unexpected native function")
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION)
      do
         fatal("unexpected user function")
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION)
      do
         fatal("unexpected agent function")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE)
      do
         music := a_music.value
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE)
      do
         music := a_music
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR)
      do
         fatal("unexpected yield iterator")
      end

feature {MIXUP_NO_VALUE}
   visit_no_value (a_no_value: MIXUP_NO_VALUE)
      do
         create {MIXUP_ZERO_MUSIC} music.make(source)
      end

feature {}
   make (a_source: like source)
      require
         a_source /= Void
      do
         source := a_source
      ensure
         source = a_source
      end

   music: MIXUP_MUSIC

invariant
   source /= Void

end -- class MIXUP_MUSIC_EVALUATOR
