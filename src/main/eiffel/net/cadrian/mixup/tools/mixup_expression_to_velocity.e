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
class MIXUP_EXPRESSION_TO_VELOCITY
   --
   -- Main class of mix-x2v
   --

insert
   ARGUMENTS
   LOGGING

create {}
   make

feature {}
   make is
      local
         mid_in: BINARY_FILE_READ
         mid_src: MIXUP_MIDI_FILE_READ
      do
         if argument_count /= 2 then
            log.error.put_line("Usage: #(1) <in.mid> <out.mid>" # command_name)
            log.error.put_line("The input midi file is <in.mid>")
            log.error.put_line("The output midi file is <out.mid>")
            die_with_code(1)
         end
         create mid_in.connect_to(argument(1))
         if not mid_in.is_connected then
            log.error.put_line("File not found: #(1)" # argument(1))
            die_with_code(1)
         end
         create mid_src.connect_to(mid_in)
         check
            mid_src.is_connected
         end
         mid_src.decode
         if mid_src.has_error then
            mid_src.disconnect
            log.error.put_line("Error while reading MIDI file: #(1)" # mid_src.error)
            die_with_code(1)
         end
         source_midi := mid_src.decoded
         check
            source_midi /= Void
         end
         log.info.put_line("MIDI file has #(1) #(2)" # &(source_midi.track_count)
                           # (if source_midi.track_count= 1 then "track" else "tracks" end))
         mid_src.disconnect
      end

   source_midi: MIXUP_MIDI_FILE

end -- class MIXUP_EXPRESSION_TO_VELOCITY
