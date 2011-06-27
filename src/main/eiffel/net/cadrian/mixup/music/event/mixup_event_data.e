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
expanded class MIXUP_EVENT_DATA
--
-- Data common to all events.
--

insert
   ANY
      redefine out_in_tagged_out_memory
      end

feature {ANY}
   source: MIXUP_SOURCE
   start_time: INTEGER_64
   instrument: MIXUP_INSTRUMENT
   staff_id: INTEGER
   voice_id: INTEGER

   set (a_source: like source; a_start_time: like start_time; a_instrument: like instrument; a_staff_id: like staff_id; a_voice_id: like voice_id) is
      require
         a_source /= Void
         a_instrument /= Void
         not is_set
      do
         source := a_source
         start_time := a_start_time
         instrument := a_instrument
         staff_id := a_staff_id
         voice_id := a_voice_id
      ensure
         source = a_source
         start_time = a_start_time
         instrument = a_instrument
         staff_id = a_staff_id
         voice_id = a_voice_id
         is_set
      end

   is_set: BOOLEAN is
      do
         Result := source /= Void
      end

   out_in_tagged_out_memory is
      do
         if is_set then
            tagged_out_memory.append(once "source=")
            source.out_in_tagged_out_memory
            tagged_out_memory.append(once ", time=")
            start_time.append_in(tagged_out_memory)
            tagged_out_memory.append(once ", instrument=")
            instrument.name.out_in_tagged_out_memory
            tagged_out_memory.append(once ", staff=")
            staff_id.append_in(tagged_out_memory)
            tagged_out_memory.append(once ", voice=")
            voice_id.append_in(tagged_out_memory)
         else
            tagged_out_memory.append(once "data not set")
         end
      end

invariant
   is_set implies instrument /= Void

end -- class MIXUP_EVENT_DATA
