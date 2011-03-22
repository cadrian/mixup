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
deferred class MIXUP_EVENTS_ITERATOR

inherit
   ITERATOR[MIXUP_EVENT]
      undefine
         is_equal
      end
   COMPARABLE

feature {ANY}
   infix "<" (other: MIXUP_EVENTS_ITERATOR): BOOLEAN is
      do
         if is_off then
            Result := not other.is_off
         elseif other.is_off then
            Result := False
         else
            Result := item < other.item
         end
      end

feature {}
   iterable_generation: INTEGER is 0

end -- class MIXUP_EVENTS_ITERATOR
