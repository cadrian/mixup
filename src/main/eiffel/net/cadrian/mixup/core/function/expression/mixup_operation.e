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
deferred class MIXUP_OPERATION

insert
   MIXUP_ERRORS

feature {}
   as_integer (value: MIXUP_VALUE): INTEGER_64 is
      local
         int: MIXUP_INTEGER
      do
         if not (int ?:= value) then
            fatal("bad type")
         else
            int ::= value
            Result := int.value
         end
      end

   as_real (value: MIXUP_VALUE): REAL is
      local
         real: MIXUP_REAL
      do
         if not (real ?:= value) then
            fatal("bad type")
         else
            real ::= value
            Result := real.value
         end
      end

   as_string (value: MIXUP_VALUE): MIXUP_STRING is
      do
         if not (Result ?:= value) then
            fatal("bad type")
         else
            Result ::= value
         end
      end

end -- class MIXUP_OPERATION
