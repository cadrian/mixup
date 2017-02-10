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
   make
      do
         if argument_count /= 2 then
            log.error.put_line("Usage: #(1) <in.mid> <out.mid>" # command_name)
            log.error.put_line("The input midi file is <in.mid>")
            log.error.put_line("The output midi file is <out.mid>")
            die_with_code(1)
         end
         log.info.put_line("**** Reading source midi...")
         read_source_midi(argument(1))
         log.info.put_line("**** Generating events...")
         generate_target_midi
         log.info.put_line("**** Writing target midi...")
         write_target_midi(argument(2))
         log.info.put_line("**** Done.")
      end

   read_source_midi (file: STRING)
      local
         mid_in: BINARY_FILE_READ
         mid_src: MIXUP_MIDI_FILE_READ
      do
         create mid_in.connect_to(file)
         if not mid_in.is_connected then
            log.error.put_line("File not found: #(1)" # file)
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
         source_midi.end_all_tracks
         log.info.put_line("max time: #(1)" # &(source_midi.max_time))
      ensure
         source_midi /= Void
      end

   generate_target_midi
      local
         sequencer: MIXUP_EXPRESSION_TO_VELOCITY_SEQUENCER
      do
         prepare_target_midi
         create sequencer.make(source_midi)
         from
            sequencer.start
         until
            sequencer.is_off
         loop
            target_midi.track(sequencer.track_index).add_event(sequencer.time, sequencer.event)
            sequencer.next
         end
         target_midi.end_all_tracks
      ensure
         target_midi /= Void
      end

   prepare_target_midi
      local
         i: INTEGER
      do
         create target_midi.make(source_midi.division)
         from
            i := 1
         until
            i > source_midi.track_count
         loop
            target_midi.add_track(create {MIXUP_MIDI_TRACK}.make)
            i := i + 1
         end
      ensure
         target_midi /= Void
      end

   write_target_midi (file: STRING)
      require
         target_midi /= Void
      local
         mid_out: BINARY_FILE_WRITE
         mid_tgt: MIXUP_MIDI_FILE_WRITE
      do
         create mid_out.connect_to(file)
         if not mid_out.is_connected then
            log.error.put_line("Could not write file: #(2)" # file)
            die_with_code(1)
         end
         create mid_tgt.connect_to(mid_out)
         target_midi.encode_to(mid_tgt)
         mid_tgt.disconnect
      end

feature {}
   source_midi: MIXUP_MIDI_FILE
   target_midi: MIXUP_MIDI_FILE

   time: INTEGER_64
   max_time: INTEGER_64

end -- class MIXUP_EXPRESSION_TO_VELOCITY
