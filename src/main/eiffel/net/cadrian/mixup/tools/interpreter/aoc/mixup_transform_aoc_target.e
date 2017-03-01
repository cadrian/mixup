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
class MIXUP_TRANSFORM_AOC_TARGET

inherit
   MIXUP_TRANSFORM_AOC_EXPRESSION

create {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   make

feature {MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR}
   target: MIXUP_TRANSFORM_VALUE

feature {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   accept (visitor: MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR)
      do
         visitor.visit_target(Current)
      end

feature {}
   make (a_target: like target)
      require
         a_target /= Void
      do
         target := a_target
      ensure
         target = a_target
      end

invariant
   target /= Void

end -- class MIXUP_TRANSFORM_AOC_TARGET
