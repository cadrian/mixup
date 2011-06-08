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
class MIXUP_MIDI_CHANNEL_PRESSURE

inherit
   MIXUP_MIDI_EVENT

create {ANY}
   make

feature {ANY}
   event_type: INTEGER_8 is 0xd0

   pressure: INTEGER_8

feature {}
   make (a_channel: like channel; a_pressure: like pressure) is
      require
         a_channel.in_range(0, 15)
      do
         channel := a_channel
         pressure := a_pressure
      ensure
         channel = a_channel
         pressure = a_pressure
      end

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM) is
      do
         stream.put_byte(pressure)
      end

end -- class MIXUP_MIDI_CHANNEL_PRESSURE
