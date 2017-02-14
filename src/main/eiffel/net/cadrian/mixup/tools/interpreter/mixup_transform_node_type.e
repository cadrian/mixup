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
      end

   is_comparable: BOOLEAN
      deferred
      end

   type_of (operator: STRING; right: MIXUP_TRANSFORM_NODE_TYPE): MIXUP_TRANSFORM_NODE_TYPE
      deferred
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

invariant
   name /= Void

end -- class MIXUP_TRANSFORM_NODE_TYPE
