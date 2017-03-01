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
class MIXUP_TRANSFORM_ASSIGN_RUNNER

inherit
   MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER

insert
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM_INTERPRETER}
   make

feature {MIXUP_TRANSFORM_INTERPRETER}
   run
      local
         i: INTEGER
         exp: MIXUP_TRANSFORM_AOC_EXPRESSION
         type_builder: MIXUP_TRANSFORM_AOC_TYPE_BUILDER
         assigner: MIXUP_TRANSFORM_AOC_ASSIGNER
      do
         create type_builder.make(value)
         from
            i := expression_string.upper
         until
            i < expression_string.lower
         loop
            exp := expression_string.item(i)
            exp.accept(type_builder)
            i := i - 1
         end
         if type_builder.actual_type /= type_unknown and then type_builder.expected_type /= type_builder.actual_type then
            error := "type mismatch: expected #(1) but got #(2) instead" # type_builder.expected_type.name # type_builder.actual_type.name
         else
            create assigner.make(context, value, type_builder.expected_type)
            from
               i := expression_string.lower
            until
               assigner.error /= Void or else i > expression_string.upper
            loop
               exp := expression_string.item(i)
               exp.accept(assigner)
               i := i + 1
            end
            if assigner.error = Void then
               assigner.done
            end
            if assigner.error /= Void then
               error := assigner.error
            end
         end
      end

feature {}
   make (a_context: DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]; a_value: like value)
      require
         a_context /= Void
         a_value /= Void
      do
         create expression_string
         context := a_context
         value := a_value
      ensure
         context = a_context
         value = a_value
      end

   context: DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]
   value: MIXUP_TRANSFORM_VALUE
   writable: MIXUP_TRANSFORM_VALUE

invariant
   context /= Void
   value /= Void

end -- class MIXUP_TRANSFORM_ASSIGN_RUNNER
