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
class MIXUP_TRANSFORM_NODE_TYPE_STRING

inherit
   MIXUP_TRANSFORM_NODE_TYPE_IMPL[STRING]

insert
   LOGGING
      undefine
         is_equal
      end
   MIXUP_TRANSFORM_NODE_TYPES
      undefine
         is_equal
      end

create {MIXUP_TRANSFORM_NODE_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN True

   type_of (operator: STRING; right: MIXUP_TRANSFORM_NODE_TYPE): MIXUP_TRANSFORM_NODE_TYPE
      do
         inspect operator
         when "*" then
            if right = type_numeric then
               Result := Current
            end
         when "+" then
            if right.same_dynamic_type(Current) then
               Result := Current
            end
         else
         end
      end

feature {MIXUP_TRANSFORM_NODE_TYPES}
   init
      do
      end

end -- class MIXUP_TRANSFORM_NODE_TYPE_STRING
