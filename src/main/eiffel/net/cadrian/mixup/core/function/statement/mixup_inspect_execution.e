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
class MIXUP_INSPECT_EXECUTION

inherit
   MIXUP_EXECUTION_CONTEXT

create {ANY}
   make

feature {ANY}
   match (a_inspect_branch: MIXUP_INSPECT_BRANCH): BOOLEAN is
      do
         match_ := False
         value := a_inspect_branch.expression.eval(context, context.player, True)
         if value = Void then
            fatal("value could not be computed")
         else
            expression.accept(Current)
            if match_ then
               Result := True
               context.add_statements(a_inspect_branch.statements)
            end
            value := Void
         end
      end

feature {}
   match_: BOOLEAN
   value: MIXUP_VALUE

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      local
         value_boolean: MIXUP_BOOLEAN
      do
         if value_boolean ?:= value then
            value_boolean ::= value
            match_ := a_boolean.value = value_boolean.value
         end
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      local
         value_integer: MIXUP_INTEGER
      do
         if value_integer ?:= value then
            value_integer ::= value
            match_ := a_integer.value = value_integer.value
         end
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      local
         value_real: MIXUP_REAL
      do
         if value_real ?:= value then
            value_real ::= value
            match_ := a_real.value = value_real.value
         end
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      local
         value_string: MIXUP_STRING
      do
         if value_string ?:= value then
            value_string ::= value
            match_ := a_string.value = value_string.value
         end
      end

feature {MIXUP_LIST}
   visit_list (a_list: MIXUP_LIST) is
      local
         i: INTEGER
      do
         from
            i := a_list.lower
         until
            match_ or else i > a_list.upper
         loop
            a_list.item(i).accept(Current)
            i := i + 1
         end
      end

feature {MIXUP_SEQ}
   visit_seq (a_seq: MIXUP_SEQ) is
      local
         i: INTEGER
      do
         from
            i := a_seq.lower
         until
            match_ or else i > a_seq.upper
         loop
            a_seq.item(i).accept(Current)
            i := i + 1
         end
      end

feature {MIXUP_DICTIONARY}
   visit_dictionary (a_dictionary: MIXUP_DICTIONARY) is
      do
         fatal("cannot match on a dictionary")
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         fatal("cannot match on music")
      end

feature {MIXUP_MUSIC_STORE}
   visit_music_store (a_music: MIXUP_MUSIC_STORE) is
      do
         fatal("cannot match on music store")
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         fatal("cannot match on iterator")
      end

feature {}
   make (a_source: like source; a_context: like context; a_expression: MIXUP_EXPRESSION) is
      require
         a_source /= Void
         a_context /= Void
         a_expression /= Void
      do
         source := a_source
         context := a_context
         expression := a_expression.eval(a_context, a_context.player, True)
      ensure
         source = a_source
         context = a_context
      end

   expression: MIXUP_VALUE

end -- class MIXUP_INSPECT_EXECUTION
