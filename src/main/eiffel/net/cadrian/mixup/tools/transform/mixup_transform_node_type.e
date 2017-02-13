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
class MIXUP_TRANSFORM_NODE_TYPE

inherit
   HASHABLE

create {MIXUP_TRANSFORM_NODE_TYPES}
   make

feature {ANY}
   name: FIXED_STRING

   hash_code: INTEGER then name.hash_code
      end

   is_equal (other: like Current): BOOLEAN then other = Current
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
