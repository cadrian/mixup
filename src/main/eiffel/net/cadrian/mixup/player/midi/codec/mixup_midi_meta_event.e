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
      end

create {ANY}
   make

feature {ANY}
   code: INTEGER_8
   data: FIXED_STRING

   byte_size: INTEGER is
      do
         Result := 2 + byte_size_variable(data.count) + data.count
      end

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM) is
      local
         i: INTEGER
      do
         stream.put_byte(0xff)
         stream.put_byte(code)
         stream.put_variable(data.count)
         from
            i := data.lower
         until
            i > data.upper
         loop
            stream.put_byte(data.item(i).code.to_integer_8)
            i := i + 1
         end
      end

feature {}
   make (a_code: like code; a_data: ABSTRACT_STRING) is
      require
         valid_code(code)
         a_data /= Void
      do
         code := a_code
         data := a_data.intern
      ensure
         code = a_code
         data = a_data.intern
      end

invariant
   valid_code(code)
   data /= Void

end -- class MIXUP_MIDI_META_EVENT
