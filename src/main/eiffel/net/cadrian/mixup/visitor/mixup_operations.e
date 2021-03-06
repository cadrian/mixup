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
class MIXUP_OPERATIONS

inherit
   MIXUP_VALUE_VISITOR

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   item (a_source: like source; a_value: MIXUP_VALUE): MIXUP_OPERATION
      require
         a_value /= Void
      do
         source := a_source
         a_value.accept(Current)
         Result := op
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR)
      do
         fatal("bad type")
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT)
      do
         fatal("bad type")
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT)
      do
         fatal("bad type")
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN)
      do
         fatal("bad type")
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER)
      do
         fatal("bad type")
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT)
      do
         fatal("bad type")
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER)
      do
         op := op_integer
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL)
      do
         op := op_real
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING)
      do
         op := op_string
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE)
      do
         fatal("bad type")
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST)
      do
         fatal("bad type")
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ)
      do
         fatal("bad type")
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY)
      do
         fatal("bad type")
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION)
      do
         fatal("bad type")
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION)
      do
         fatal("bad type")
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION)
      do
         fatal("bad type")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE)
      do
         fatal("bad type")
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE)
      do
         fatal("bad type")
      end

feature {}
   make
      do
      end

   op: MIXUP_OPERATION

   op_integer: MIXUP_OPERATIONS_INTEGER
      require
         source /= Void
      do
         create Result.make(source)
      end

   op_real: MIXUP_OPERATIONS_REAL
      require
         source /= Void
      do
         create Result.make(source)
      end

   op_string: MIXUP_OPERATIONS_STRING
      require
         source /= Void
      do
         create Result.make(source)
      end

end -- class MIXUP_OPERATIONS
