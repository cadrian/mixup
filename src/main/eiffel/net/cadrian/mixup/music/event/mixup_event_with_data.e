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
deferred class MIXUP_EVENT_WITH_DATA

inherit
   MIXUP_EVENT

feature {ANY}
   data: MIXUP_EVENT_DATA

   time: INTEGER_64 is
      do
         Result := data.start_time
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.extend('[')
         tagged_out_memory.append(generating_type)
         tagged_out_memory.append(once ": ")
         data.out_in_tagged_out_memory
         out_in_extra_data
         tagged_out_memory.extend(']')
      end

   needs_instrument: BOOLEAN is
      deferred
      end

feature {}
   make (a_data: like data) is
      require
         a_data.source /= Void
         needs_instrument implies a_data.instrument /= Void
      do
         source := a_data.source
         data := a_data
      ensure
         data = a_data
      end

   out_in_extra_data is
      do
      end

invariant
   source = data.source
   needs_instrument implies data.instrument /= Void

end -- class MIXUP_EVENT_WITH_DATA
