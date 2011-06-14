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
expanded class MIXUP_MIDI_EVENTS

feature {ANY}
   controller_event (channel: INTEGER_8; knob: MIXUP_MIDI_CONTROLLER_KNOB; value: INTEGER): MIXUP_MIDI_EVENT is
      require
         channel.in_range(0, 15)
         knob.valid_value(value)
      do
         create {MIXUP_MIDI_CONTROLLER} Result.make(channel, knob, value)
      end

   program_change_event (channel: INTEGER_8; patch: INTEGER_8): MIXUP_MIDI_EVENT is
      require
         channel.in_range(0, 15)
         patch >= 0
      do
         create {MIXUP_MIDI_PROGRAM_CHANGE} Result.make(channel, patch)
      end

   note_event (channel: INTEGER_8; on_off: BOOLEAN; pitch: INTEGER_8; velocity: INTEGER_8): MIXUP_MIDI_EVENT is
      require
         channel.in_range(0, 15)
      do
         if on_off then
            create {MIXUP_MIDI_NOTE_ON} Result.make(channel, pitch, velocity)
         else
            create {MIXUP_MIDI_NOTE_OFF} Result.make(channel, pitch, velocity)
         end
      end

   pitch_bend_event (channel: INTEGER_8; pitch: INTEGER): MIXUP_MIDI_EVENT is
      require
         channel.in_range(0, 15)
         pitch.in_range(0, 0x00003fff)
      do
         create {MIXUP_MIDI_PITCH_BEND} Result.make(channel, pitch)
      end

   channel_pressure_event (channel: INTEGER_8; pressure: INTEGER_8): MIXUP_MIDI_EVENT is
      require
         channel.in_range(0, 15)
         pressure >= 0
      do
         create {MIXUP_MIDI_CHANNEL_PRESSURE} Result.make(channel, pressure)
      end

   key_pressure_event (channel: INTEGER_8; key: INTEGER_8; pressure: INTEGER_8): MIXUP_MIDI_EVENT is
      require
         channel.in_range(0, 15)
         key >= 0
         pressure >= 0
      do
         create {MIXUP_MIDI_KEY_PRESSURE} Result.make(channel, key, pressure)
      end

end -- class MIXUP_MIDI_EVENTS
