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
class MIXUP_SINGLE_EVENT_ITERATOR
   --
   -- Trivial iterator.
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
   start
      do
         is_off := False
         debug
            shown := False
         end
      end

   is_off: BOOLEAN

   item: MIXUP_EVENT
      do
         Result := item_
         debug
            if not shown then
               log.trace.put_line(generating_type | once ": item=" | &Result)
               shown := True
            end
         end
      end

   next
      do
         is_off := True
      end

feature {}
   make (a_item: like item)
      require
         a_item /= Void
      do
         item_ := a_item
      ensure
         item_ = a_item
         not is_off
      end

   item_: MIXUP_EVENT
   shown: BOOLEAN

invariant
   item_ /= Void

end -- class MIXUP_SINGLE_EVENT_ITERATOR
