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
class MIXUP_MIDI_NOTE_ON

inherit
   MIXUP_MIDI_EVENT

create {ANY}
   make

feature {ANY}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR)
      do
         visitor.visit_mixup_midi_note_on(Current)
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append("note on: ")
         pitch.append_in(tagged_out_memory)
         tagged_out_memory.append(" (velocity: ")
         velocity.append_in(tagged_out_memory)
         tagged_out_memory.append(")")
      end

   event_type: INTEGER_32
      once
         Result := event_note_on
      end

   byte_size: INTEGER is 3
   pitch: INTEGER_32
   velocity: INTEGER_32

feature {}
   make (a_channel: like channel; a_pitch: like pitch; a_velocity: like velocity)
      require
         a_channel.in_range(0, 15)
         a_pitch >= 0
         a_velocity >= 0
      do
         channel := a_channel
         pitch := a_pitch
         velocity := a_velocity
      ensure
         channel = a_channel
         pitch = a_pitch
         velocity = a_velocity
      end

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT)
      do
         debug
            log.trace.put_line(once "channel " | &channel | once ": key=" | &pitch | once " on")
         end
         stream.put_byte(pitch + context.transpose_half_tones)
         stream.put_byte(velocity)
      end

invariant
   pitch >= 0
   velocity >= 0

end -- class MIXUP_MIDI_NOTE_ON
