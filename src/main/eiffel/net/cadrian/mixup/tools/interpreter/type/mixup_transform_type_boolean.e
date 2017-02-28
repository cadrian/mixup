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
class MIXUP_TRANSFORM_TYPE_BOOLEAN

inherit
   MIXUP_TRANSFORM_TYPE_IMPL[BOOLEAN]

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
      local
         l, r: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         l ::= left
         r ::= right
         Result := l.value = r.value
      end

   gt (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      do
         set_error("internal error: unexpected call")
      end

   add (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot add booleans")
         else
            set_error("cannot add boolean and #(1)" # right.type.name)
         end
      end

   subtract (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot subtract booleans")
         else
            set_error("cannot subtract boolean and #(1)" # right.type.name)
         end
      end

   multiply (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot multiply booleans")
         else
            set_error("cannot multiply boolean and #(1)" # right.type.name)
         end
      end

   divide (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot divide booleans")
         else
            set_error("cannot divide boolean and #(1)" # right.type.name)
         end
      end

   power (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot take power of booleans")
         else
            set_error("cannot take power of boolean by #(1)" # right.type.name)
         end
      end

   has_field (field_name: STRING): BOOLEAN
      do
         check not Result end
      end

   field (field_name: STRING; target: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("internal error: unexpected call")
      end

   value_of (image: MIXUP_TRANSFORM_NODE_IMAGE): MIXUP_TRANSFORM_VALUE
      local
         bool: MIXUP_TRANSFORM_NODE_IMAGE_TYPED[BOOLEAN]
         res: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         if bool ?:= image then
            bool ::= image
            create res.make
            res.set_value(bool.value)
            Result := res
         else
            set_error("internal error: invalid type")
         end
      end

end -- class MIXUP_TRANSFORM_TYPE_BOOLEAN
