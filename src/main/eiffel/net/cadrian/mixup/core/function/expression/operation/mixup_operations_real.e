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
class MIXUP_OPERATIONS_REAL

inherit
   MIXUP_ADDITION
   MIXUP_DIVISION
   MIXUP_MULTIPLICATION
   MIXUP_SUBTRACTION
   MIXUP_TAKE_POWER

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   add (left, right: MIXUP_VALUE): MIXUP_REAL
      do
         create Result.make(source, as_real(left) + as_real(right))
      end

feature {ANY}
   divide (left, right: MIXUP_VALUE): MIXUP_REAL
      do
         create Result.make(source, as_real(left) / as_real(right))
      end

feature {ANY}
   multiply (left, right: MIXUP_VALUE): MIXUP_REAL
      do
         create Result.make(source, as_real(left) * as_real(right))
      end

feature {ANY}
   subtract (left, right: MIXUP_VALUE): MIXUP_REAL
      do
         create Result.make(source, as_real(left) - as_real(right))
      end

feature {ANY}
   power (left, right: MIXUP_VALUE): MIXUP_REAL
      do
         create Result.make(source, as_real(left) ^ as_integer(right).to_integer_32)
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

end -- class MIXUP_OPERATIONS_REAL
