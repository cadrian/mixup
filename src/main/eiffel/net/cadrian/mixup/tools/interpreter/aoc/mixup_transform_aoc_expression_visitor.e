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
deferred class MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR

feature {MIXUP_TRANSFORM_AOC_FIELD}
   visit_field (a_field: MIXUP_TRANSFORM_AOC_FIELD)
      require
         a_field /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_AOC_INDEX}
   visit_index (a_index: MIXUP_TRANSFORM_AOC_INDEX)
      require
         a_index /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_AOC_TARGET}
   visit_target (a_target: MIXUP_TRANSFORM_AOC_TARGET)
      require
         a_target /= Void
      deferred
      end

end -- class MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR
