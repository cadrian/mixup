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
deferred class MIXUP_EVENTS_CACHED_ITERATOR

inherit
   MIXUP_EVENTS_ITERATOR

insert
   LOGGING
      undefine is_equal
      end

feature {ANY}
   item: like item_memory is
      do
         Result := item_memory
         if Result = Void then
            Result := fetch_item
            debug
               log.trace.put_line(generating_type + ": item=" + Result.out)
            end
            item_memory := Result
         end
      end

   next is
      do
         go_next
         item_memory := Void
      end

feature {}
   item_memory: MIXUP_EVENT

   fetch_item: like item_memory is
      require
         item_memory = Void
         not is_off
      deferred
      ensure
         Result /= Void
      end

   go_next is
      require
         fetched: item_memory /= Void
      deferred
      end

end -- class MIXUP_EVENTS_CACHED_ITERATOR
