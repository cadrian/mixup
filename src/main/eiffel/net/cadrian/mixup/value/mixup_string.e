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
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: FIXED_STRING

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_string(Current)
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(image)
      end

feature {}
   image: FIXED_STRING

   make (a_value, a_image: ABSTRACT_STRING) is
      require
         a_value /= Void
         a_image /= Void
      do
         value := a_value.intern
         image := a_image.intern
      ensure
         value = a_value.intern
         image = a_image.intern
      end

invariant
   value /= Void

end -- class MIXUP_STRING
