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
   byte_size: INTEGER is
      deferred
      ensure then
         Result > 0
      end

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT) is
      local
         code: INTEGER_8
      do
         code := event_type | channel
         stream.put_byte(code)
         put_args(stream, context)
      end

   event_type: INTEGER_8 is
      deferred
      end

   channel: INTEGER_8

   set_channel (a_channel: like channel) is
      require
         a_channel.in_range(0, 15)
      do
         channel := a_channel
      ensure
         channel = a_channel
      end

feature {}
   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT) is
      require
         stream.is_connected
         context /= Void
      deferred
      end

invariant
   channel.in_range(0, 15)
   event_type & 0xf0 = event_type

end -- class MIXUP_MIDI_EVENT
