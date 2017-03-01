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
class MIXUP_TRANSFORM_AOC_TYPE_BUILDER

inherit
   MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR

insert
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   make

feature {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   actual_type: MIXUP_TRANSFORM_TYPE
   expected_type: MIXUP_TRANSFORM_TYPE

feature {MIXUP_TRANSFORM_AOC_FIELD}
   visit_field (a_field: MIXUP_TRANSFORM_AOC_FIELD)
      do
         -- currently only event supports fields
         if expected_type /= type_unknown then
            expected_type := type_event
         end
      end

feature {MIXUP_TRANSFORM_AOC_INDEX}
   visit_index (a_index: MIXUP_TRANSFORM_AOC_INDEX)
      do
         if expected_type /= type_unknown then
            expected_type := type_associative(a_index.index.type, expected_type)
            -- TODO check type using a_index.map
         end
      end

feature {MIXUP_TRANSFORM_AOC_TARGET}
   visit_target (a_target: MIXUP_TRANSFORM_AOC_TARGET)
      do
         actual_type := a_target.target.type
      end

feature {}
   make (value: MIXUP_TRANSFORM_VALUE)
      require
         value /= Void
      do
         expected_type := value.type
      end

end -- class MIXUP_TRANSFORM_AOC_TYPE_BUILDER
