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
class MIXUP_MIDI_PITCH_BEND

inherit
   MIXUP_MIDI_EVENT

create {ANY}
   make

feature {ANY}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR)
      do
         visitor.visit_mixup_midi_pitch_bend(Current)
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append("pitch bend: ")
         pitch.append_in(tagged_out_memory)
      end

   event_type: INTEGER_32
      once
         Result := event_pitch_bend
      end

   byte_size: INTEGER is 3
   pitch: INTEGER

feature {}
   make (a_channel: like channel; a_pitch: like pitch)
      require
         a_channel.in_range(0, 15)
         a_pitch.in_range(0, 0x00003fff)
      do
         channel := a_channel
         pitch := a_pitch
      ensure
         channel = a_channel
         pitch = a_pitch
      end

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT)
      do
         debug
            log.trace.put_line(once "channel " | &channel | once ": pitch bend " | &pitch)
         end
         stream.put_byte((pitch & 0x0000007f).to_integer_8)
         stream.put_byte(((pitch |>> 7) & 0x0000007f).to_integer_8)
      end

invariant
   pitch.in_range(0, 0x00003fff)

end -- class MIXUP_MIDI_PITCH_BEND
