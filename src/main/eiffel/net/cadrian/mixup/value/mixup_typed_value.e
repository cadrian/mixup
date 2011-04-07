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
class MIXUP_TYPED_VALUE[E_]

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: E_

feature {}
   make (a_source: like source; a_value: like value) is
      require
         a_source /= Void
      do
         source := a_source
         value := a_value
      ensure
         source = a_source
         value = a_value
      end

end -- class MIXUP_TYPED_VALUE
