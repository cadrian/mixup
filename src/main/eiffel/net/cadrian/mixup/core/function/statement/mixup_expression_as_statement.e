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
class MIXUP_EXPRESSION_AS_STATEMENT

inherit
   MIXUP_STATEMENT
      redefine
         out_in_tagged_out_memory
      end
   MIXUP_VALUE_VISITOR
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   expression: MIXUP_EXPRESSION

   call (a_commit_context: like commit_context) is
      local
         value: MIXUP_VALUE
      do
         value := expression.eval(a_commit_context, True)
         if value /= Void then
            commit_context := a_commit_context
            value.accept(Current)
            commit_context.reset
         end
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_expression_as_statement(Current)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "expression: ")
         source.out_in_tagged_out_memory
      end

feature {}
   commit_context: MIXUP_COMMIT_CONTEXT

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT) is
      do
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT) is
      do
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      do
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT) is
      do
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE) is
      do
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST) is
      do
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ) is
      do
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY) is
      do
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      do
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION) is
      do
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      local
         context: MIXUP_EVENTS_ITERATOR_CONTEXT
      do
         context.set_instrument(commit_context.instrument)
         a_music.value.new_events_iterator(context).do_all(agent commit_context.player.play)
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE) is
      local
         context: MIXUP_EVENTS_ITERATOR_CONTEXT
      do
         context.set_instrument(commit_context.instrument)
         a_music.new_events_iterator(context).do_all(agent commit_context.player.play)
      end

feature {}
   make (a_source: like source; a_expression: like expression) is
      require
         a_source /= Void
         a_expression /= Void
      do
         source := a_source
         expression := a_expression
      ensure
         source = a_source
         expression = a_expression
      end

invariant
   expression /= Void

end -- class MIXUP_EXPRESSION_AS_STATEMENT
