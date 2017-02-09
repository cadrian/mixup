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
class MIXUP_MIDI_META_EVENT

inherit
   MIXUP_MIDI_CODEC

insert
   MIXUP_MIDI_META_EVENTS
      export
         {ANY} valid_code;
         {} all
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR)
      do
         visitor.visit_mixup_midi_meta_event(Current)
      end

   out_in_tagged_out_memory
      local
         i: INTEGER
      do
         tagged_out_memory.append("meta event: ")
         tagged_out_memory.append(name)
         tagged_out_memory.append(" [")
         from
            i := data.lower
         until
            i > data.upper
         loop
            if i > data.lower then
               tagged_out_memory.extend(' ')
            end
            tagged_out_memory.append(data.item(i).code.to_hexadecimal.substring(3, 4))
            i := i + 1
         end
         tagged_out_memory.append("]")
      end

   name: FIXED_STRING
   code: INTEGER_32
   data: FIXED_STRING

   byte_size: INTEGER
      do
         Result := 2 + byte_size_variable(data.count) + data.count
      end

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT)
      local
         i, byte: INTEGER
      do
         debug
            log.trace.put_line(name)
         end
         stream.put_byte(event_meta_event)
         stream.put_byte(code)
         stream.put_variable(data.count)
         from
            i := data.lower
         until
            i > data.upper
         loop
            byte := data.item(i).code
            stream.put_byte(byte)
            i := i + 1
         end
      end

feature {}
   make (a_code: like code; a_data: ABSTRACT_STRING; a_name: ABSTRACT_STRING)
      require
         valid_code(code)
         a_data /= Void
         a_name /= Void
      do
         code := a_code
         data := a_data.intern
         name := a_name.intern
      ensure
         code = a_code
         data = a_data.intern
         name = a_name.intern
      end

invariant
   valid_code(code)
   data /= Void
   name /= Void

end -- class MIXUP_MIDI_META_EVENT
