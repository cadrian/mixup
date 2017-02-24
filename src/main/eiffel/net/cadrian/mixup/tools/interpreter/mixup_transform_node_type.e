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
deferred class MIXUP_TRANSFORM_NODE_TYPE

inherit
   HASHABLE

feature {ANY}
   name: FIXED_STRING

   hash_code: INTEGER then name.hash_code
      end

   is_equal (other: like Current): BOOLEAN then other = Current
      ensure then
         name = other.name implies Result
      end

   is_comparable: BOOLEAN
      deferred
      end

feature {ANY}
   error: STRING
      do
         Result := error_ref.item
      end

feature {MIXUP_TRANSFORM_INTERPRETER}
   eq (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      require
         error = Void
         left.type = Current
         right.type = Current
      deferred
      end

   gt (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      require
         error = Void
         is_comparable
         left.type = Current
         right.type = Current
      deferred
      end

   add (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      require
         error = Void
         left.type = Current
         right.type = Current
      deferred
      ensure
         Result /= Void implies Result.type = Current
         Result = Void implies error /= Void
      end

   subtract (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      require
         error = Void
         left.type = Current
         right.type = Current
      deferred
      ensure
         Result /= Void implies Result.type = Current
         Result = Void implies error /= Void
      end

   multiply (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      require
         error = Void
         left.type = Current
         right.type = Current
      deferred
      ensure
         Result /= Void implies Result.type = Current
         Result = Void implies error /= Void
      end

   divide (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      require
         error = Void
         left.type = Current
         right.type = Current
      deferred
      ensure
         Result /= Void implies Result.type = Current
         Result = Void implies error /= Void
      end

   power (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      require
         error = Void
         left.type = Current
         right.type = Current
      deferred
      ensure
         Result /= Void implies Result.type = Current
         Result = Void implies error /= Void
      end

   has_field (field_name: STRING): BOOLEAN
      deferred
      end

   field (field_name: STRING; target: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      require
         error = Void
         has_field(field_name)
      deferred
      ensure
         Result = Void implies error /= Void
      end

   value_of (image: STRING): MIXUP_TRANSFORM_VALUE
      require
         error = Void
         image /= Void
      deferred
      ensure
         Result = Void implies error /= Void
      end

feature {MIXUP_TRANSFORM_NODE_TYPES}
   init
      deferred
      end

feature {}
   make (a_name: ABSTRACT_STRING)
      require
         a_name /= Void
      do
         name := a_name.intern
      ensure
         name = a_name.intern
      end

   set_error (a_error: like error)
      require
         error = Void
      do
         error_ref.set_item(a_error)
      ensure
         error = a_error
      end

   error_ref: REFERENCE[STRING]
      once
         create Result
      end

invariant
   name /= Void

end -- class MIXUP_TRANSFORM_NODE_TYPE
