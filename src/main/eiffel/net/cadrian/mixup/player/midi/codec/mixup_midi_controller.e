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
class MIXUP_MIDI_CONTROLLER

inherit
   MIXUP_MIDI_EVENT
      redefine
         encode_to
      end

create {ANY}
   make

feature {ANY}
   event_type: INTEGER_8 is
      once
         Result := event_controller
      end

   knob: MIXUP_MIDI_CONTROLLER_KNOB
   value: INTEGER

   byte_size: INTEGER is
      do
         Result := knob.byte_size
      end

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT) is
      local
         code: INTEGER_8
      do
         debug
            log.trace.put_string(once "channel " | &channel | once ": controller ")
         end
         code := event_type | channel
         knob.encode_to(code, value, stream)
      end

feature {}
   make (a_channel: like channel; a_knob: like knob; a_value: like value) is
      require
         a_channel.in_range(0, 15)
         a_knob.valid_value(a_value)
      do
         channel := a_channel
         knob := a_knob
         value := a_value
      ensure
         channel = a_channel
         knob = a_knob
         value = a_value
      end

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT) is
      do
         crash
      end

end -- class MIXUP_MIDI_CONTROLLER
