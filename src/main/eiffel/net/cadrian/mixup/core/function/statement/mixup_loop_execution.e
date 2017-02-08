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
   MIXUP_STATEMENT

create {ANY}
   make

feature {ANY}
   call (a_commit_context: MIXUP_COMMIT_CONTEXT)
      do
         check
            commit_context = a_commit_context
         end
         value.accept(Current)
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN)
      do
         fatal("cannot iterate on a boolean")
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER)
      do
         fatal("cannot iterate on an integer")
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL)
      do
         fatal("cannot iterate on a real")
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING)
      do
         fatal("cannot iterate on a string")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE)
      do
         fatal("cannot iterate on music")
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE)
      do
         fatal("cannot iterate on music store")
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE)
      do
         visit_iterable(a_tuple)
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST)
      do
         visit_iterable(a_list)
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ)
      do
         visit_iterable(a_seq)
      end

feature {}
   visit_iterable (a_iterable: MIXUP_ITERABLE)
      local
         item: MIXUP_VALUE
      do
         if iterable = Void then
            iterable ::= a_iterable.eval(commit_context, True)
            if iterable = Void then
               fatal("could not compute value")
            else
               iterable_index := a_iterable.lower
            end
         end
         if iterable_index <= a_iterable.upper then
            item := iterable.item(iterable_index)
            context.set_local(loop_.identifier, item)
            context.add_statement(Current)
            context.add_statements(loop_.statements)
            iterable_index := iterable_index + 1
         end
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY)
      do
         fatal("cannot iterate on a dictionary")
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR)
      do
         if more and then a_yield_iterator.has_next then
            a_yield_iterator.next(commit_context)
         end
         context.set_local(loop_.identifier, a_yield_iterator.value)
         if a_yield_iterator.has_next then
            context.add_statement(Current)
         end
         context.add_statements(loop_.statements)
         more := True
      end

feature {}
   make (a_source: like source; a_commit_context: like commit_context; a_loop: like loop_; a_value: like value)
      require
         a_source /= Void
         a_commit_context.context /= Void
         {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_commit_context.context
         a_loop /= Void
         a_value /= Void
      do
         source := a_source
         commit_context := a_commit_context
         loop_ := a_loop
         value := a_value
      ensure
         source = a_source
         commit_context = a_commit_context
         loop_ = a_loop
         value = a_value
      end

   loop_: MIXUP_LOOP
   more: BOOLEAN -- for yield functions: handles the first-call step, where the first yielded value is already available
   iterable_index: INTEGER -- for iterables
   iterable: MIXUP_ITERABLE
   value: MIXUP_VALUE

end -- class MIXUP_LOOP_EXECUTION
