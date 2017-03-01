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
class MIXUP_TRANSFORM_AOC_FIELD

inherit
   MIXUP_TRANSFORM_AOC_EXPRESSION

create {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   make

feature {MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR}
   field: STRING

feature {MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER}
   accept (visitor: MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR)
      do
         visitor.visit_field(Current)
      end

feature {}
   make (a_field: like field)
      require
         a_field /= Void
      do
         field := a_field
      ensure
         field = a_field
      end

invariant
   field /= Void

end -- class MIXUP_TRANSFORM_AOC_FIELD
