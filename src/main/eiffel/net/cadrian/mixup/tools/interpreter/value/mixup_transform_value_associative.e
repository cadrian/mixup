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

create {ANY}
   make

feature {ANY}
   type: MIXUP_TRANSFORM_TYPE_ASSOCIATIVE

   accept (a_visitor: MIXUP_TRANSFORM_VALUE_VISITOR)
      do
         a_visitor.visit_value_associative(Current)
      end

   is_equal (other: like Current): BOOLEAN
      local
         i: ITERATOR[MIXUP_TRANSFORM_VALUE]
         lv, rv: MIXUP_TRANSFORM_VALUE
      do
         if count = other.count and then type = other.type then
            from
               i := new_iterator_on_keys
               Result := True
            until
               not Result or else i.is_off
            loop
               if other.has_value(i.item) then
                  lv := value(i.item)
                  rv := other.value(i.item)
                  Result := lv.type = rv.type and then lv.type.eq(lv, rv)
               end
               i.next
            end
         end
      end

   hash_code: INTEGER
      do
         Result := to_pointer.hash_code
      end

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
         Result := values.at(key)
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
         a_type /= Void
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
