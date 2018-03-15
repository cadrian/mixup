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
class MIXUP_MIDI_CONTROLLER_SWITCH

inherit
   MIXUP_MIDI_CONTROLLER_KNOB

insert
   MIXUP_MIDI_EVENT_TYPES
      undefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {MIXUP_MIDI_CONTROLLER}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR; codec: MIXUP_MIDI_CONTROLLER)
      do
         visitor.visit_mixup_midi_controller_switch(codec, Current)
      end

feature {ANY}
   out_in_tagged_out_memory
      do
         tagged_out_memory.append("switch: ")
         tagged_out_memory.append(name)
      end

   name: FIXED_STRING
   code: INTEGER_32
   byte_size: INTEGER is 3

   valid_value (value: INTEGER): BOOLEAN
      do
         Result := value.in_range(0, 127)
      end

   encode_to (channel: INTEGER_32; value: INTEGER; stream: MIXUP_MIDI_OUTPUT_STREAM)
      local
         message_code: INTEGER_32
      do
         debug
            log.trace.put_line(name | once "=" | &value)
         end
         message_code := event_controller | channel
         stream.put_byte(message_code)
         stream.put_byte(code)
         stream.put_byte(value)
      end

feature {}
   make (cod: INTEGER_32; a_name: ABSTRACT_STRING)
      require
         a_name /= Void
      do
         code := cod
         event_type := event_controller
         name := a_name.intern
      ensure
         code = cod
         name = a_name.intern
      end

end -- class MIXUP_MIDI_CONTROLLER_SWITCH
