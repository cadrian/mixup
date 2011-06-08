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
deferred class MIXUP_MIDI_OUTPUT_STREAM

feature {ANY}
   is_connected: BOOLEAN is
      deferred
      end

   start (tracks_count: INTEGER_16) is
      require
         is_connected
      do
         put_integer_32(header_magic)
         put_integer_32(header_size)
         put_integer_16(header_type)
         put_integer_16(tracks_count)
         put_integer_16(header_timing)
      end

   next_track (length: INTEGER) is
      require
         is_connected
      do
         put_integer_32(track_magic)
         put_integer_32(length)
      end

   put_variable (variable: INTEGER_64) is
         -- A variable length value uses the low order 7 bits of a byte to represent the value or part of the
         -- value. The high order bit is an "escape" or "continuation" bit. All but the last byte of a
         -- variable length value have the high order bit set. The last byte has the high order bit
         -- cleared. The bytes always appear most significant byte first.
      require
         variable > 0
         is_connected
      do
         put_variable_byte_and_continue(variable, False)
      end

   put_byte (byte: INTEGER_8) is
      require
         is_connected
      do
         put_integer_8(byte.to_integer_32 & 0x000000ff)
      end

feature {}
   put_variable_byte_and_continue (variable: INTEGER_64; continue: BOOLEAN) is
      require
         variable > 0
         is_connected
      local
         byte: INTEGER_32
      do
         if variable >= 0x00000080 then
            put_variable_byte_and_continue(variable |>> 7, True)
         end
         byte := (variable & 0x000000000000007f).to_integer_32
         if continue then
            byte := byte | 0x00000080
         end
         put_integer_8(byte)
      end

   header_magic: INTEGER is 0x4d546864 -- "MThd"
   header_size: INTEGER is 6
   header_type: INTEGER_16 is 1
   header_timing: INTEGER_16 is 384

   track_magic: INTEGER is 0x4d54726b -- "MTrk"

feature {}
   frozen put_integer_32 (int: INTEGER_32) is
      require
         is_connected
      do
         put_integer_8((int |>> 24) & 0x000000ff)
         put_integer_8((int |>> 16) & 0x000000ff)
         put_integer_8((int |>>  8) & 0x000000ff)
         put_integer_8( int         & 0x000000ff)
      end

   frozen put_integer_16 (short: INTEGER_32) is
      require
         is_connected
         short.in_range(0, 0x0000ffff)
      do
         put_integer_8((short |>>  8) & 0x000000ff)
         put_integer_8( short         & 0x000000ff)
      end

   put_integer_8 (byte: INTEGER_32) is
      require
         is_connected
         byte.in_range(0, 0x000000ff)
      deferred
      end

end -- class MIXUP_MIDI_OUTPUT_STREAM
