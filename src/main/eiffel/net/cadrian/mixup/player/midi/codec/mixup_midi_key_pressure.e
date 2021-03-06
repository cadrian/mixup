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
class MIXUP_MIDI_KEY_PRESSURE

inherit
   MIXUP_MIDI_EVENT

create {ANY}
   make

feature {ANY}
   accept (visitor: MIXUP_MIDI_CODEC_VISITOR)
      do
         visitor.visit_mixup_midi_key_pressure(Current)
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append("key pressure: ")
         pressure.append_in(tagged_out_memory)
      end

   event_type: INTEGER_32
      once
         Result := event_key_pressure
      end

   byte_size: INTEGER is 3
   key: INTEGER_32
   pressure: INTEGER_32

feature {}
   make (a_channel: like channel; a_key: like key; a_pressure: like pressure)
      require
         a_channel.in_range(0, 15)
         a_key >= 0
         a_pressure >= 0
      do
         channel := a_channel
         key := a_key
         pressure := a_pressure
      ensure
         channel = a_channel
         key = a_key
         pressure = a_pressure
      end

   put_args (stream: MIXUP_MIDI_OUTPUT_STREAM; context: MIXUP_MIDI_ENCODE_CONTEXT)
      do
         debug
            log.trace.put_line(once "channel " | &channel | once ": pressure=" | &pressure | once " on key " | &key)
         end
         stream.put_byte(key)
         stream.put_byte(pressure)
      end

invariant
   key >= 0
   pressure >= 0

end -- class MIXUP_MIDI_KEY_PRESSURE
