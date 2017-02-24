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
deferred class MIXUP_MIDI_CODEC

insert
   LOGGING
      undefine
         out_in_tagged_out_memory, is_equal
      end

feature {ANY}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR)
      require
         visitor /= Void
      deferred
      end

   byte_size: INTEGER
      deferred
      ensure
         Result >= 0
      end

   encode_to (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT)
      require
         stream.is_connected
         context /= Void
      deferred
      end

   byte_size_variable (variable: INTEGER_64): INTEGER
      do
         inspect
            variable
         when 0..0x000000000000007f then
            Result := 1
         when 0x0000000000000080..0x0000000000003fff then
            Result := 2

         -- are the values below really used?

         when 0x0000000000004000..0x00000000001fffff then
            Result := 3
         else
            Result := 4
         end
      end

end -- class MIXUP_MIDI_CODEC
