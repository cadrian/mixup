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
class MIXUP_TRANSFORM_AOC_INDEX

inherit
   MIXUP_TRANSFORM_AOC_EXPRESSION

create {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   make

feature {MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR}
   index: MIXUP_TRANSFORM_VALUE

feature {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   accept (visitor: MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR)
      do
         visitor.visit_index(Current)
      end

feature {}
   make (a_index: like index)
      require
         a_index /= Void
      do
         index := a_index
      ensure
         index = a_index
      end

invariant
   index /= Void

end -- class MIXUP_TRANSFORM_AOC_INDEX
