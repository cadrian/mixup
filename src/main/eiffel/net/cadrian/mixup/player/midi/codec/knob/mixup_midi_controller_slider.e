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
class MIXUP_MIDI_CONTROLLER_SLIDER

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
         visitor.visit_mixup_midi_controller_slider(codec, Current)
      end

feature {ANY}
   out_in_tagged_out_memory
      do
         tagged_out_memory.append("slider: ")
         tagged_out_memory.append(name)
      end

   name: FIXED_STRING
   coarse_code: INTEGER_32
   fine_code: INTEGER_32

   is_coarse: BOOLEAN
      do
         Result := fine_code = 0
      end

   is_fine: BOOLEAN
      do
         Result := not is_coarse
      end

   byte_size: INTEGER
      do
         if is_coarse then
            Result := 3
         else
            Result := 7
         end
      end

   encode_to (channel: INTEGER_32; value: INTEGER; stream: MIXUP_MIDI_OUTPUT_STREAM)
      local
         message_code: INTEGER_32
      do
         debug
            log.trace.put_line(name | once "=" | &value)
         end
         message_code := event_controller | channel
         if is_coarse then
            stream.put_byte(message_code)
            stream.put_byte(coarse_code)
            stream.put_byte((value & 0x0000007f))
         else
            stream.put_byte(message_code)
            stream.put_byte(fine_code)
            stream.put_byte(((value |>> 7) & 0x0000007f))

            message_code := event_type | channel
            stream.put_byte(0) -- at the same time
            stream.put_byte(message_code)
            stream.put_byte((value & 0x0000007f))
         end
      end

   valid_value (value: INTEGER): BOOLEAN
      do
         if is_coarse then
            Result := value.in_range(0, 0x0000007f)
         else
            Result := value.in_range(0, 0x00003fff)
         end
      end

feature {}
   make (c, f, evt: INTEGER_32; a_name: ABSTRACT_STRING)
      require
         f /= 0 implies f > c
         a_name /= Void
      do
         coarse_code := c
         fine_code := f
         event_type := evt
         name := a_name.intern
      ensure
         coarse_code = c
         fine_code = f
         name = a_name.intern
      end

invariant
   fine_code /= 0 implies fine_code > coarse_code

end -- class MIXUP_MIDI_CONTROLLER_SLIDER
