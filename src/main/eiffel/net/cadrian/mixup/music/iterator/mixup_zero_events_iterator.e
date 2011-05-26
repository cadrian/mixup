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
class MIXUP_ZERO_EVENTS_ITERATOR
   --
   -- Trivial iterator: always `is_off'.
   --

inherit
   MIXUP_EVENTS_ITERATOR

insert
   LOGGING
      undefine is_equal
      end

create {ANY}
   make

feature {ANY}
   start is
      do
      end

   is_off: BOOLEAN is True

   item: MIXUP_EVENT is
      do
         crash
      end

   next is
      do
      end

feature {}
   make is
      do
      end

invariant
   is_off

end -- class MIXUP_ZERO_EVENTS_ITERATOR