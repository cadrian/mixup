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

feature {ANY}
   valid_value (value: INTEGER): BOOLEAN is
      deferred
      end

   encode_to (message_code: INTEGER_8; value: INTEGER; stream: MIXUP_MIDI_OUTPUT_STREAM) is
      require
         valid_value(value)
         stream.is_connected
      deferred
      end

end -- class MIXUP_MIDI_CONTROLLER_KNOB
