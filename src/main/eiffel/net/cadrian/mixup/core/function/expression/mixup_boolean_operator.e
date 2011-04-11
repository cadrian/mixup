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
deferred class MIXUP_BOOLEAN_OPERATOR

inherit
   MIXUP_BINARY_EXPRESSION
   MIXUP_VALUE_VISITOR

insert
   MIXUP_ERRORS

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
         value := a_boolean.value
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      do
         fatal("bad type")
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT) is
      do
         fatal("bad type")
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
         fatal("bad type")
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
         fatal("bad type")
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
         fatal("bad type")
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST) is
      do
         fatal("bad type")
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ) is
      do
         fatal("bad type")
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY) is
      do
         fatal("bad type")
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

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         fatal("bad type")
      end

feature {}
   value: BOOLEAN

end -- class MIXUP_BOOLEAN_OPERATOR