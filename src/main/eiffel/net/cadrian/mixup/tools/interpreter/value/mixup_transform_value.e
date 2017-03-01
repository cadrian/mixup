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
deferred class MIXUP_TRANSFORM_VALUE

inherit
   HASHABLE

feature {ANY}
   type: MIXUP_TRANSFORM_TYPE
      deferred
      end

   accept (a_visitor: MIXUP_TRANSFORM_VALUE_VISITOR)
      deferred
      end

invariant
   type /= Void

end -- class MIXUP_TRANSFORM_VALUE
