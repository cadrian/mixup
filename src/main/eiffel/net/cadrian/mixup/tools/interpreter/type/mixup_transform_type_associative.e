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
class MIXUP_TRANSFORM_TYPE_ASSOCIATIVE

inherit
   MIXUP_TRANSFORM_TYPE
      rename
         make as make_type
      end

create {MIXUP_TRANSFORM_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN False

   index_type, value_type: MIXUP_TRANSFORM_TYPE

feature {MIXUP_TRANSFORM_INTERPRETER, MIXUP_TRANSFORM_TYPE, MIXUP_TRANSFORM_VALUE}
   eq (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      local
         l, r: MIXUP_TRANSFORM_VALUE_ASSOCIATIVE
      do
         l ::= left
         r ::= right
         Result := l.is_equal(r)
      end

   gt (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      do
         set_error("internal error: unexpected call")
      end

   add (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot add associatives")
         else
            set_error("cannot add associative and #(1)" # right.type.name)
         end
      end

   subtract (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot subtract associatives")
         else
            set_error("cannot subtract associative and #(1)" # right.type.name)
         end
      end

   multiply (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot multiply associatives")
         else
            set_error("cannot multiply associative and #(1)" # right.type.name)
         end
      end

   divide (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot divide associatives")
         else
            set_error("cannot divide associative and #(1)" # right.type.name)
         end
      end

   power (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot take power of associatives")
         else
            set_error("cannot take power of associative by #(1)" # right.type.name)
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

feature {MIXUP_TRANSFORM_TYPES}
   init
      do
      end

feature {}
   make (a_name: ABSTRACT_STRING; index, value: MIXUP_TRANSFORM_TYPE)
      require
         a_name /= Void
         index.is_comparable
         value /= Void
      do
         make_type(a_name)
         index_type := index
         value_type := value
      ensure
         name = a_name.intern
         index_type = index
         value_type = value
      end

invariant
   index_type.is_comparable
   value_type /= Void

end -- class MIXUP_TRANSFORM_TYPE_ASSOCIATIVE
