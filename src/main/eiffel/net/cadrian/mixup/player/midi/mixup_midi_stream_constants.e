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
deferred class MIXUP_MIDI_STREAM_CONSTANTS

feature {}
   header_magic: INTEGER is 0x4d546864 -- "MThd"
   header_size: INTEGER is 6
   header_type_0: INTEGER_16 is 0
   header_type_1: INTEGER_16 is 1
   header_type_2: INTEGER_16 is 2

   track_magic: INTEGER is 0x4d54726b -- "MTrk"

end -- class MIXUP_MIDI_STREAM_CONSTANTS
