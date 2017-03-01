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
class MIXUP_TRANSFORM_AOC_ASSIGNER

inherit
   MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR

insert
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   make

feature {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   error: ABSTRACT_STRING

   done
      do
         if on_done /= Void then
            on_done.call([True])
         end
      end

feature {MIXUP_TRANSFORM_AOC_FIELD}
   visit_field (a_field: MIXUP_TRANSFORM_AOC_FIELD)
      do
         check
            on_done /= Void
         end
         on_done.call([False])
         on_done := agent do_visit_field(?, a_field)
      end

feature {}
   do_visit_field (is_done: BOOLEAN; a_field: MIXUP_TRANSFORM_AOC_FIELD)
      require
         error = Void
      do
         if target.type.has_field(a_field.field) then
            if is_done then
               error := "cannot assign field, please build a new event instead"
            else
               target := target.type.field(a_field.field, target)
               if target.type.error /= Void then
                  error := target.type.error
               end
            end
         else
            error := "no such field: #(1)" # a_field.field
         end
      end

feature {MIXUP_TRANSFORM_AOC_INDEX}
   visit_index (a_index: MIXUP_TRANSFORM_AOC_INDEX)
      do
         check
            on_done /= Void
         end
         on_done.call([False])
         on_done := agent do_visit_index(?, a_index)
      end

feature {}
   do_visit_index (is_done: BOOLEAN; a_index: MIXUP_TRANSFORM_AOC_INDEX)
      require
         error = Void
      local
         m: MIXUP_TRANSFORM_VALUE_ASSOCIATIVE
      do
         if m ?:= target then
            m ::= target
            if is_done then
               m.set_value(value, a_index.index)
            elseif m.has_value(a_index.index) then
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
      do
         check
            on_done = Void
         end
         on_done := agent do_visit_target(?, a_target)
      end

feature {}
   do_visit_target (is_done: BOOLEAN; a_target: MIXUP_TRANSFORM_AOC_TARGET)
      require
         error = Void
      local
         u: MIXUP_TRANSFORM_VALUE_UNKNOWN
      do
         check
            a_target.target.type = type_unknown
         end
         u ::= a_target.target
         if is_done then
            context.put(value, u.name)
         elseif u.old_value = Void then
            target := target_type.new_value
            context.put(target, u.name)
         else
            target := u.old_value
            check
               context.at(u.name) = target
            end
         end
      end

feature {}
   make (a_context: like context; a_value: like value; a_target_type: like target_type)
      require
         a_context /= Void
         a_value /= Void
         a_target_type /= Void
      do
         context := a_context
         value := a_value
         target_type := a_target_type
      ensure
         context = a_context
         value = a_value
         target_type = a_target_type
         target = Void
      end

   value: MIXUP_TRANSFORM_VALUE
   target: MIXUP_TRANSFORM_VALUE
   target_type: MIXUP_TRANSFORM_TYPE
   context: DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]

   on_done: PROCEDURE[TUPLE[BOOLEAN]]

invariant
   context /= Void
   value /= Void
   target /= Void

end -- class MIXUP_TRANSFORM_AOC_ASSIGNER
