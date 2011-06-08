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
class MIXUP_MIDI_PROGRAM_CHANGE

inherit
   MIXUP_MIDI_EVENT

create {ANY}
   make

feature {ANY}
   event_type: INTEGER_8 is 0xc0

   patch: INTEGER_8

feature {}
   make (a_channel: like channel; a_patch: like patch) is
      require
         a_channel.in_range(0, 15)
      do
         channel := a_channel
         patch := a_patch
      ensure
         channel = a_channel
         patch = a_patch
      end

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM) is
      do
         stream.put_byte(patch)
      end

end -- class MIXUP_MIDI_PROGRAM_CHANGE
