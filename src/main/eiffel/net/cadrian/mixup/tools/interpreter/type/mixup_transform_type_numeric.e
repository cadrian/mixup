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
class MIXUP_TRANSFORM_TYPE_NUMERIC

inherit
   MIXUP_TRANSFORM_TYPE_IMPL[INTEGER]

create {MIXUP_TRANSFORM_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN True

feature {MIXUP_TRANSFORM_TYPES}
   init
      do
      end

feature {MIXUP_TRANSFORM_INTERPRETER, MIXUP_TRANSFORM_TYPE, MIXUP_TRANSFORM_VALUE}
   eq (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      local
         l, r: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         l ::= left
         r ::= right
         Result := l.value = r.value
      end

   gt (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      local
         l, r: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         l ::= left
         r ::= right
         Result := l.value > r.value
      end

   add (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         l, r, res: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         if right.type = Current then
            l ::= left
            r ::= right
            create res.make
            res.set_value(l.value + r.value)
            Result := res
         else
            set_error("cannot add numeric and #(1)" # right.type.name)
         end
      end

   subtract (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         l, r, res: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         if right.type = Current then
            l ::= left
            r ::= right
            create res.make
            res.set_value(l.value - r.value)
            Result := res
         else
            set_error("cannot subtract numeric and #(1)" # right.type.name)
         end
      end

   multiply (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         l, r, res: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         if right.type = Current then
            l ::= left
            r ::= right
            if r.value /= 0 then
               create res.make
               res.set_value(l.value * r.value)
               Result := res
            else
               set_error("divide by zero")
            end
         else
            set_error("cannot multiply numeric and #(1)" # right.type.name)
         end
      end

   divide (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         l, r, res: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         if right.type = Current then
            l ::= left
            r ::= right
            create res.make
            res.set_value(l.value // r.value)
            Result := res
         else
            set_error("cannot divide numeric and #(1)" # right.type.name)
         end
      end

   power (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         l, r, res: MIXUP_TRANSFORM_VALUE_NUMERIC; n: INTEGER_64
      do
         if right.type = Current then
            l ::= left
            r ::= right
            n := l.value ^ r.value
            if n.fit_integer_32 then
               create res.make
               res.set_value(n.to_integer_32)
               Result := res
            else
               set_error("numeric overflow")
            end
         else
            set_error("cannot take power of numeric by #(1)" # right.type.name)
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
         num: MIXUP_TRANSFORM_NODE_IMAGE_TYPED[INTEGER]
         res: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         if num ?:= image then
            num ::= image
            create res.make
            res.set_value(num.value)
            Result := res
         else
            set_error("internal error: invalid type")
         end
      end

end -- class MIXUP_TRANSFORM_TYPE_NUMERIC
