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
class MIXUP_LOOP_EXECUTION

inherit
   MIXUP_EXECUTION_CONTEXT

create {ANY}
   make

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
         not_yet_implemented -- error: cannot iterate on a boolean
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
         not_yet_implemented -- error: cannot iterate on an integer
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
         not_yet_implemented -- error: cannot iterate on a real
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
         not_yet_implemented -- error: cannot iterate on a string
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         not_yet_implemented -- error: cannot iterate on music
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         if more and then a_yield_iterator.has_next then
            a_yield_iterator.next
         end
         context.resolver.set_local(loop_.identifier, a_yield_iterator.value)
         if a_yield_iterator.has_next then
            context.add_statement(loop_)
         end
         context.add_statements(loop_.statements)
         more := True
      end

feature {}
   make (a_context: like context; a_loop: like loop_) is
      require
         a_context /= Void
         a_loop /= Void
      do
         context := a_context
         loop_ := a_loop
      ensure
         context = a_context
         loop_ = a_loop
      end

   loop_: MIXUP_LOOP
   more: BOOLEAN -- handles the first-call step, where the first yielded value is already available

end -- class MIXUP_LOOP_EXECUTION
