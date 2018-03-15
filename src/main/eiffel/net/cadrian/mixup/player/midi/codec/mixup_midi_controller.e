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

insert
   MIXUP_MIDI_EVENT_TYPES
      undefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR)
      do
         knob.accept(visitor, Current)
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append("controller: ")
         value.append_in(tagged_out_memory)
         tagged_out_memory.append(" (")
         knob.out_in_tagged_out_memory
         tagged_out_memory.append(")")
      end

   event_type: INTEGER_32
      do
         Result := event_controller
      end

   knob: MIXUP_MIDI_CONTROLLER_KNOB
   value: INTEGER

   byte_size: INTEGER
      do
         Result := knob.byte_size
      end

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT)
      do
         debug
            log.trace.put_string(once "channel " | &channel | once ": controller ")
         end
         knob.encode_to(channel, value, stream)
      end

feature {}
   make (a_channel: like channel; a_knob: like knob; a_value: like value)
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

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT)
      do
         crash
      end

end -- class MIXUP_MIDI_CONTROLLER
