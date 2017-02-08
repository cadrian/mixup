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
class MIXUP_OPERATIONS_STRING

inherit
   MIXUP_ADDITION

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   add (left, right: MIXUP_VALUE): MIXUP_STRING
      local
         s, i: STRING
      do
         s := as_string(left).value.out
         s.append(as_string(right).value)
         i := as_string(left).image.out
         i.append(as_string(right).image)
         create Result.make(source, s.intern, i.intern)
      end

feature {}
   make (a_source: like source)
      require
         a_source /= Void
      do
         source := a_source
      ensure
         source = a_source
      end

end -- class MIXUP_OPERATIONS_STRING
