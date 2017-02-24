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
class MIXUP_TRANSFORM_VALUE_ASSOCIATIVE

inherit
   MIXUP_TRANSFORM_VALUE

create {MIXUP_TRANSFORM_INTERPRETER}
   make

feature {ANY}
   type: MIXUP_TRANSFORM_NODE_TYPE_ASSOCIATIVE

   has_value (key: MIXUP_TRANSFORM_VALUE): BOOLEAN
      require
         key /= Void
      do
         Result := values.has(key)
      end

   value (key: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      require
         has_value(key)
      do
         Result := values.item(key)
      end

   set_value (v, key: MIXUP_TRANSFORM_VALUE)
      require
         key /= Void
      do
         values.put(v, key)
      ensure
         has_value(key)
         value(key) = v
      end

   count: INTEGER
      do
         Result := values.count
      end

   new_iterator_on_keys: ITERATOR[MIXUP_TRANSFORM_VALUE]
      do
         Result := values.new_iterator_on_keys
      end

feature {}
   make (a_type: like type)
      require
         type /= Void
         {MIXUP_TRANSFORM_NODE_TYPE_ASSOCIATIVE} ?:= a_type
      do
         type := a_type
         create values
      ensure
         type = a_type
         values.is_empty
      end

   values: HASHED_DICTIONARY[MIXUP_TRANSFORM_VALUE, MIXUP_TRANSFORM_VALUE]

invariant
   values /= Void

end -- class MIXUP_TRANSFORM_VALUE_ASSOCIATIVE
