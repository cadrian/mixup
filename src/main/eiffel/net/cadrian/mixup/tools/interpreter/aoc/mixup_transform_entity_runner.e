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
class MIXUP_TRANSFORM_ENTITY_RUNNER

inherit
   MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER
   MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR

insert
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM_INTERPRETER}
   make

feature {MIXUP_TRANSFORM_INTERPRETER}
   run
      local
         i: INTEGER
      do
         from
            i := expression_string.lower
         until
            error /= Void or else i > expression_string.upper
         loop
            expression_string.item(i).accept(Current)
            i := i + 1
         end
         if error = Void then
            on_done.call([target])
         end
      end

feature {MIXUP_TRANSFORM_AOC_FIELD}
   visit_field (a_field: MIXUP_TRANSFORM_AOC_FIELD)
      do
         check
            error = Void
         end
         if target.type.has_field(a_field.field) then
            target := target.type.field(a_field.field, target)
            if target.type.error /= Void then
               error := target.type.error
            end
         else
            error := "no such field: #(1)" # a_field.field
         end
      end

feature {MIXUP_TRANSFORM_AOC_INDEX}
   visit_index (a_index: MIXUP_TRANSFORM_AOC_INDEX)
      local
         m: MIXUP_TRANSFORM_VALUE_ASSOCIATIVE
      do
         check
            error = Void
         end
         if m ?:= target then
            m ::= target
            if m.has_value(a_index.index) then
               target := m.value(a_index.index)
            else
               error := "no such index"
            end
         else
            error := "type #(1) is not indexable" # target.type.name
         end
      end

feature {MIXUP_TRANSFORM_AOC_TARGET}
   visit_target (a_target: MIXUP_TRANSFORM_AOC_TARGET)
      local
         u: MIXUP_TRANSFORM_VALUE_UNKNOWN
      do
         check
            error = Void
            a_target.target.type = type_unknown
            target = Void
         end
         u ::= a_target.target
         target := u.old_value
         check
            context.at(u.name) = target
         end
      end

feature {}
   make (a_context: like context; a_on_done: like on_done)
      require
         a_context /= Void
         a_on_done /= Void
      do
         context := a_context
         on_done := a_on_done
         create expression_string
      ensure
         context = a_context
         on_done = a_on_done
      end

   context: DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]
   on_done: PROCEDURE[TUPLE[MIXUP_TRANSFORM_VALUE]]

   target: MIXUP_TRANSFORM_VALUE

invariant
   context /= Void
   on_done /= Void

end -- class MIXUP_TRANSFORM_ENTITY_RUNNER
