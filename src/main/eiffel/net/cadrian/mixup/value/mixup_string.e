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
class MIXUP_STRING

inherit
   MIXUP_TYPED_VALUE[FIXED_STRING]
      rename
         make as typed_make
      undefine
         is_equal
      end
   COMPARABLE

create {ANY}
   make

feature {ANY}
   image: FIXED_STRING

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_string(Current)
      end

   infix "<" (other: like Current): BOOLEAN is
      do
         Result := value < other.value
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(image)
      end

feature {}
   make (a_value, a_image: ABSTRACT_STRING) is
      require
         a_value /= Void
         a_image /= Void
      do
         typed_make(a_value.intern)
         image := a_image.intern
      ensure
         value = a_value.intern
         image = a_image.intern
      end

invariant
   value /= Void

end -- class MIXUP_STRING
