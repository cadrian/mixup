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
deferred class MIXUP_VALUE_VISITOR

inherit
   VISITOR

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT)
      require
         a_agent /= Void
      deferred
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN)
      require
         a_boolean /= Void
      deferred
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER)
      require
         a_identifier /= Void
      deferred
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT)
      require
         a_result /= Void
      deferred
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER)
      require
         a_integer /= Void
      deferred
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL)
      require
         a_real /= Void
      deferred
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING)
      require
         a_string /= Void
      deferred
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE)
      require
         a_tuple /= Void
      deferred
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST)
      require
         a_list /= Void
      deferred
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ)
      require
         a_seq /= Void
      deferred
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY)
      require
         a_dictionary /= Void
      deferred
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION)
      require
         a_function /= Void
      deferred
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION)
      require
         a_function /= Void
      deferred
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION)
      require
         a_function /= Void
      deferred
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE)
      require
         a_music /= Void
      deferred
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE)
      require
         a_music /= Void
      deferred
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT)
      require
         a_open_argument /= Void
      deferred
      end

feature {MIXUP_VALUE_FACTORY}
   visit_value_factory (a_value_factory: MIXUP_VALUE_FACTORY)
      require
         a_value_factory /= Void
      do
         -- defaults to nothing
         sedb_breakpoint
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR)
      require
         a_yield_iterator /= Void
      deferred
      end

feature {MIXUP_NO_VALUE}
   visit_no_value (a_no_value: MIXUP_NO_VALUE)
      require
         a_no_value /= Void
      do
         -- default implementation does nothing because it is a very
         -- peculiar case
      end

end -- class MIXUP_VALUE_VISITOR
