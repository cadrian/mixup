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
class MIXUP_TRANSFORM_TYPE_UNKNOWN

inherit
   MIXUP_TRANSFORM_TYPE

create {MIXUP_TRANSFORM_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN False

feature {MIXUP_TRANSFORM_TYPES}
   init
      do
      end

feature {MIXUP_TRANSFORM_INTERPRETER, MIXUP_TRANSFORM_TYPE, MIXUP_TRANSFORM_VALUE}
   eq (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      do
         check not Result end
      end

   gt (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      do
         set_error("internal error: unexpected call")
      end

   add (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("unknown type")
      end

   subtract (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("unknown type")
      end

   multiply (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("unknown type")
      end

   divide (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("unknown type")
      end

   power (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("unknown type")
      end

feature {ANY}
   has_field (field_name: STRING): BOOLEAN
      do
         check not Result end
      end

   field (field_name: STRING; target: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("internal error: unexpected call")
      end

   value_of (image: MIXUP_TRANSFORM_NODE_IMAGE): MIXUP_TRANSFORM_VALUE
      do
         set_error("internal error: invalid type")
      end

   new_value: MIXUP_TRANSFORM_VALUE
      do
         set_error("internal error: cannot create unknown values")
      end

end -- class MIXUP_TRANSFORM_TYPE_UNKNOWN
