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
class MIXUP_TRANSFORM_VALUE_STRING

inherit
   MIXUP_TRANSFORM_VALUE_IMPL[STRING]

insert
   MIXUP_TRANSFORM_TYPES

create {ANY}
   make

feature {ANY}
   type: MIXUP_TRANSFORM_TYPE_STRING then type_string
      end

   accept (a_visitor: MIXUP_TRANSFORM_VALUE_VISITOR)
      do
         a_visitor.visit_value_string(Current)
      end

   hash_code: INTEGER
      do
         Result := value.hash_code
      end

feature {}
   make
      do
      end

invariant
   type = type_string

end -- class MIXUP_TRANSFORM_VALUE_STRING
