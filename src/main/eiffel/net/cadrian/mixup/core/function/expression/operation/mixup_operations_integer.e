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
class MIXUP_OPERATIONS_INTEGER

inherit
   MIXUP_ADDITION
   MIXUP_DIVISION
   MIXUP_INTEGER_DIVISION
   MIXUP_INTEGER_REMAINDER
   MIXUP_MULTIPLICATION
   MIXUP_SUBTRACTION
   MIXUP_TAKE_POWER

create {ANY}
   make

feature {ANY}
   add (left, right: MIXUP_VALUE): MIXUP_INTEGER is
      do
         create Result.make(as_integer(left) + as_integer(right))
      end

   divide (left, right: MIXUP_VALUE): MIXUP_REAL is
      do
         create Result.make(as_integer(left) / as_integer(right))
      end

   integer_divide (left, right: MIXUP_VALUE): MIXUP_INTEGER is
      do
         create Result.make(as_integer(left) // as_integer(right))
      end

   integer_modulo (left, right: MIXUP_VALUE): MIXUP_INTEGER is
      do
         create Result.make(as_integer(left) \\ as_integer(right))
      end

   multiply (left, right: MIXUP_VALUE): MIXUP_INTEGER is
      do
         create Result.make(as_integer(left) * as_integer(right))
      end

   subtract (left, right: MIXUP_VALUE): MIXUP_INTEGER is
      do
         create Result.make(as_integer(left) - as_integer(right))
      end

   power (left, right: MIXUP_VALUE): MIXUP_INTEGER is
      do
         create Result.make(as_integer(left) ^ as_integer(right))
      end

feature {}
   make is
      do
      end

end -- class MIXUP_INTEGER_OPERATION
