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
class AUX_MIXUP_MOCK_MIDI_OUTPUT

inherit
   MIXUP_MIDI_OUTPUT_STREAM
   STREAM
      undefine
         dispose
      end

insert
   BINARY_FILE_WRITE
      rename
         make as bfw_make
         put_byte as bfw_put_byte
      export {}
         all
      redefine
         write_buffer
      end
   STRING_HANDLER

create {ANY}
   make

feature {ANY}
   append_in (string: STRING) is
      require
         not string.is_empty
      local
         i: INTEGER
      do
         if buffer_position > 0 then
            string.ensure_capacity(string.count + buffer_position)
            from
               i := 0
            until
               i = buffer_position
            loop
               string.extend(buffer.item(i))
               i := i + 1
            end
         end
      end

   clear_count is
      do
         buffer_position := 0
      end

feature {}
   make is
      do
         bfw_make
         path := once ""
      end

   put_integer_32 (int: INTEGER_32) is
      do
         put_integer_32_native_endian(int)
      end

   put_integer_16 (short: INTEGER_32) is
      do
         put_integer_16_native_endian((short & 0xffff).to_integer_16)
      end

   put_integer_8 (byte: INTEGER_32) is
      do
         bfw_put_byte(byte)
      end

   write_buffer is
      do
         std_error.put_line("**** AUX_MIXUP_MOCK_MIDI_OUTPUT: buffer overflow!")
         clear_count
      end

invariant
   is_connected

end -- class AUX_MIXUP_MOCK_MIDI_OUTPUT
