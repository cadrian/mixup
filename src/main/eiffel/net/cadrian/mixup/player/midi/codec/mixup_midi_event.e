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
deferred class MIXUP_MIDI_EVENT

inherit
   MIXUP_MIDI_CODEC

feature {ANY}
   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM) is
      local
         code: INTEGER_8
      do
         code := event_type | channel
         stream.put_byte(code)
         put_args(stream)
      end

   event_type: INTEGER_8 is
      deferred
      end

   channel: INTEGER_8

feature {}
   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM) is
      require
         stream.is_connected
      deferred
      end

invariant
   channel.in_range(0, 15)
   event_type & 0xf0 = event_type

end -- class MIXUP_MIDI_EVENT