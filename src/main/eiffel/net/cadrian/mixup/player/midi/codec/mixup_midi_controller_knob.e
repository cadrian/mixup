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
deferred class MIXUP_MIDI_CONTROLLER_KNOB

insert
   LOGGING
      undefine
         out_in_tagged_out_memory
      end

feature {ANY}
   byte_size: INTEGER
      deferred
      end

   valid_value (value: INTEGER): BOOLEAN
      deferred
      end

   encode_to (message_code: INTEGER_32; value: INTEGER; stream: MIXUP_MIDI_OUTPUT_STREAM)
      require
         valid_value(value)
         stream.is_connected
      deferred
      end

   name: FIXED_STRING
      deferred
      ensure
         Result /= Void
      end

feature {MIXUP_MIDI_CONTROLLER}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR; codec: MIXUP_MIDI_CONTROLLER)
      require
         visitor /= Void
         codec /= Void
      deferred
      end

end -- class MIXUP_MIDI_CONTROLLER_KNOB
