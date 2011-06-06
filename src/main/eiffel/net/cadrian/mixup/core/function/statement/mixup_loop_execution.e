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
   call (a_context: MIXUP_USER_FUNCTION_CONTEXT) is
      do
         value.accept(Current)
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
         fatal("cannot iterate on a boolean")
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
         fatal("cannot iterate on an integer")
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
         fatal("cannot iterate on a real")
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
         fatal("cannot iterate on a string")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         fatal("cannot iterate on music")
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE) is
      do
         fatal("cannot iterate on music store")
      end

feature {MIXUP_TUPLE}
   visit_tuple (a_tuple: MIXUP_TUPLE) is
      do
         visit_iterable(a_tuple)
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST) is
      do
         visit_iterable(a_list)
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ) is
      do
         visit_iterable(a_seq)
      end

feature {}
   visit_iterable (a_iterable: MIXUP_ITERABLE) is
      local
         item: MIXUP_VALUE
      do
         if iterable = Void then
            iterable ::= a_iterable.eval(context, context.player, True)
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
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY) is
      do
         fatal("cannot iterate on a dictionary")
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         if more and then a_yield_iterator.has_next then
            a_yield_iterator.next
         end
         context.set_local(loop_.identifier, a_yield_iterator.value)
         if a_yield_iterator.has_next then
            context.add_statement(Current)
         end
         context.add_statements(loop_.statements)
         more := True
      end

feature {}
   make (a_source: like source; a_context: like context; a_loop: like loop_; a_value: like value) is
      require
         a_source /= Void
         a_context /= Void
         a_loop /= Void
         a_value /= Void
      do
         source := a_source
         context := a_context
         loop_ := a_loop
         value := a_value
      ensure
         source = a_source
         context = a_context
         loop_ = a_loop
         value = a_value
      end

   loop_: MIXUP_LOOP
   more: BOOLEAN -- for yield functions: handles the first-call step, where the first yielded value is already available
   iterable_index: INTEGER -- for iterables
   iterable: MIXUP_ITERABLE
   value: MIXUP_VALUE

end -- class MIXUP_LOOP_EXECUTION
