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
class MIXUP_IF_THEN_ELSE_EXECUTION

inherit
   MIXUP_EXECUTION_CONTEXT

create {ANY}
   make

feature {ANY}
   match (a_if: MIXUP_IF): BOOLEAN
      local
         value: MIXUP_VALUE
      do
         value := a_if.condition.eval(commit_context, True)
         if value = Void then
            fatal("value could not be computed")
         else
            match_ := False
            value.accept(Current)
            Result := match_
         end
      end

feature {}
   match_: BOOLEAN

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN)
      do
         match_ := a_boolean.value
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER)
      do
         fatal("cannot match on an integer")
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL)
      do
         fatal("cannot match on a real")
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING)
      do
         fatal("cannot match on a string")
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE)
      do
         fatal("cannot match on a tuple")
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST)
      do
         fatal("cannot match on a list")
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ)
      do
         fatal("cannot match on a seq")
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY)
      do
         fatal("cannot match on a dictionary")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE)
      do
         fatal("cannot match on music")
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE)
      do
         fatal("cannot match on music store")
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR)
      do
         fatal("cannot match on iterator")
      end

feature {}
   make (a_source: like source; a_commit_context: like commit_context)
      require
         a_commit_context.context /= Void
         {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_commit_context.context
         a_source /= Void
      do
         source := a_source
         commit_context := a_commit_context
      ensure
         source = a_source
         commit_context = a_commit_context
      end

end -- class MIXUP_IF_THEN_ELSE_EXECUTION
