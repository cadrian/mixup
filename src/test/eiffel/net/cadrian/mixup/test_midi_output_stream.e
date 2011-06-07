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
class TEST_MIDI_OUTPUT_STREAM

insert
   EIFFELTEST_TOOLS
   LOGGING

create {}
   make

feature {}
   stream: AUX_MIXUP_MOCK_MIDI_OUTPUT

   make is
      local
         note_on_event: MIXUP_MIDI_NOTE_ON
         note_off_event: MIXUP_MIDI_NOTE_OFF
         key_pressure_event: MIXUP_MIDI_KEY_PRESSURE
         channel_pressure_event: MIXUP_MIDI_CHANNEL_PRESSURE
         controller: MIXUP_MIDI_CONTROLLER
         knobs: MIXUP_MIDI_CONTROLLER_KNOBS
      do
         create stream.make

         stream.put_variable(0x0000000a)
         assert_stream("%/10/")

         stream.put_variable(0x0000007f)
         assert_stream("%/127/")

         stream.put_variable(0x00000080)
         assert_stream("%/129/%/0/")

         stream.put_variable(0x000000ff)
         assert_stream("%/129/%/127/")

         stream.put_variable(0x00008000)
         assert_stream("%/130/%/128/%/0/")

         create note_on_event.make(12, 60, 42)
         assert(note_on_event.event_type = 0x80)
         assert(note_on_event.channel = 12)
         assert(note_on_event.pitch = 60)
         assert(note_on_event.velocity = 42)
         note_on_event.encode_to(stream)
         assert_stream("%/140/%/60/%/42/") -- 140 = 0x8c = 0x80 + 12

         create note_off_event.make(3, 47, 58)
         assert(note_off_event.event_type = 0x90)
         assert(note_off_event.channel = 3)
         assert(note_off_event.pitch = 47)
         assert(note_off_event.velocity = 58)
         note_off_event.encode_to(stream)
         assert_stream("%/147/%/47/%/58/") -- 147 = 0x93 = 0x90 + 3

         create key_pressure_event.make(7, 124, 12)
         assert(key_pressure_event.event_type = 0xa0)
         assert(key_pressure_event.channel = 7)
         assert(key_pressure_event.key = 124)
         assert(key_pressure_event.pressure = 12)
         key_pressure_event.encode_to(stream)
         assert_stream("%/167/%/124/%/12/") -- 167 = 0xa7 = 0xa0 + 7

         create channel_pressure_event.make(5, 73)
         assert(channel_pressure_event.event_type = 0xd0)
         assert(channel_pressure_event.channel = 5)
         assert(channel_pressure_event.pressure = 73)
         channel_pressure_event.encode_to(stream)
         assert_stream("%/213/%/73/") -- 213 = 0xd5 = 0xd0 + 5

         create controller.make(9, knobs.expression_controller, 37)
         assert(controller.event_type = 0xb0)
         assert(controller.channel = 9)
         assert(controller.knob = knobs.expression_controller)
         controller.encode_to(stream)
         assert_stream("%/185/%/11/%/37/") -- 185 = 0xb9 = 0xb0 + 9

         create controller.make(9, knobs.expression_controller, 2048)
         assert(controller.event_type = 0xb0)
         assert(controller.channel = 9)
         assert(controller.knob = knobs.expression_controller)
         controller.encode_to(stream)
         assert_stream("%/185/%/43/%/16/%/185/%/11/%/0/") -- 185 = 0xb9 = 0xb0 + 9
      end

   assert_stream (ref: STRING) is
      local
         string: STRING
      do
         string := ""
         stream.append_in(string)
         assert(string.is_equal(ref))
         stream.clear_count
      end

end -- class TEST_MIDI_OUTPUT_STREAM
