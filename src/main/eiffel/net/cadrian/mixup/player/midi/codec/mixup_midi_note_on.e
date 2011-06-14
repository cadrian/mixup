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
class MIXUP_MIDI_NOTE_ON

inherit
   MIXUP_MIDI_EVENT

create {ANY}
   make

feature {ANY}
   event_type: INTEGER_8 is 0x90
   byte_size: INTEGER is 3

   pitch: INTEGER_8
   velocity: INTEGER_8

feature {}
   make (a_channel: like channel; a_pitch: like pitch; a_velocity: like velocity) is
      require
         a_channel.in_range(0, 15)
         a_pitch >= 0
         a_velocity >= 0
      do
         channel := a_channel
         pitch := a_pitch
         velocity := a_velocity
      ensure
         channel = a_channel
         pitch = a_pitch
         velocity = a_velocity
      end

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM) is
      do
         stream.put_byte(pitch)
         stream.put_byte(velocity)
      end

invariant
   pitch >= 0
   velocity >= 0

end -- class MIXUP_MIDI_NOTE_ON
