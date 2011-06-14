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
      do
         create stream.make
         test_variables
         test_events
         test_meta_events
         test_track
      end

   test_variables is
      do
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
      end

   test_events is
      local
         note_on_event: MIXUP_MIDI_NOTE_ON
         note_off_event: MIXUP_MIDI_NOTE_OFF
         key_pressure_event: MIXUP_MIDI_KEY_PRESSURE
         channel_pressure_event: MIXUP_MIDI_CHANNEL_PRESSURE
         controller: MIXUP_MIDI_CONTROLLER
         knobs: MIXUP_MIDI_CONTROLLER_KNOBS
         program: MIXUP_MIDI_PROGRAM_CHANGE
         pitch_bend: MIXUP_MIDI_PITCH_BEND
      do
         create note_on_event.make(12, 60, 42)
         assert(note_on_event.event_type = 0x90)
         assert(note_on_event.channel = 12)
         assert(note_on_event.pitch = 60)
         assert(note_on_event.velocity = 42)
         note_on_event.encode_to(stream)
         assert_stream("%/156/%/60/%/42/") -- 156 = 0x9c = 0x90 + 12

         create note_off_event.make(3, 47, 58)
         assert(note_off_event.event_type = 0x80)
         assert(note_off_event.channel = 3)
         assert(note_off_event.pitch = 47)
         assert(note_off_event.velocity = 58)
         note_off_event.encode_to(stream)
         assert_stream("%/131/%/47/%/58/") -- 131 = 0x83 = 0x80 + 3

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

         create controller.make(9, knobs.fine_expression_controller, 2048)
         assert(controller.event_type = 0xb0)
         assert(controller.channel = 9)
         assert(controller.knob = knobs.fine_expression_controller)
         controller.encode_to(stream)
         assert_stream("%/185/%/43/%/0/%/0/%/185/%/11/%/16/") -- 185 = 0xb9 = 0xb0 + 9

         create program.make(1, 20)
         assert(program.event_type = 0xc0)
         assert(program.channel = 1)
         assert(program.patch = 20)
         program.encode_to(stream)
         assert_stream("%/193/%/20/") -- 193 = 0xc1 = 0xc0 + 1

         create pitch_bend.make(3, 42)
         assert(pitch_bend.event_type = 0xe0)
         assert(pitch_bend.channel = 3)
         assert(pitch_bend.pitch = 42)
         pitch_bend.encode_to(stream)
         assert_stream("%/227/%/42/%/0/") -- 227 = 0xe3 = 0xe0 + 3

         create pitch_bend.make(3, 2000)
         assert(pitch_bend.event_type = 0xe0)
         assert(pitch_bend.channel = 3)
         assert(pitch_bend.pitch = 2000)
         pitch_bend.encode_to(stream)
         assert_stream("%/227/%/80/%/15/") -- 227 = 0xe3 = 0xe0 + 3
      end

   test_meta_events is
      local
         meta: MIXUP_MIDI_META_EVENTS
         event: MIXUP_MIDI_META_EVENT
      do
         create event.make(meta.lyrics, "boo!")
         assert(event.code = meta.lyrics)
         assert(event.data = "boo!".intern)
         event.encode_to(stream)
         assert_stream("%/255/%/5/%/4/boo!")
      end

   test_track is
      local
         meta: MIXUP_MIDI_META_EVENTS
         track: MIXUP_MIDI_TRACK; track_ref: STRING
         file:  MIXUP_MIDI_FILE;  file_ref:  STRING
         bfw: BINARY_FILE_WRITE
      do
         create track.make                                                   -- v_time   message
         track.add_event(  0, create {MIXUP_MIDI_PROGRAM_CHANGE}.make(4, 1)) --  0x00   0xc4 0x01
         track.add_event(  0, create {MIXUP_MIDI_NOTE_ON}.make(4, 60, 64))   --  0x00   0x94 60 64
         track.add_event( 64, create {MIXUP_MIDI_NOTE_OFF}.make(4, 60, 64))  --  0x40   0x84 60 64
         track.add_event( 64, create {MIXUP_MIDI_NOTE_ON}.make(4, 62, 64))   --  0x00   0x94 62 64
         track.add_event(128, create {MIXUP_MIDI_NOTE_OFF}.make(4, 62, 64))  --  0x40   0x84 62 64
         -- this last is mandatory at the end of every track:
         track.add_event(128, meta.end_of_track_event)                       --  0x00   0xff 0x2f 0x00
         track_ref := "MTrk%/0/%/0/%/0/%/23/%/0/%/196/%/1/%/0/%/148/%/60/%/64/%/64/%/132/%/60/%/64/%/0/%/148/%/62/%/64/%/64/%/132/%/62/%/64/%/0/%/255/%/47/%/0/"

         create file.make(384)
         assert(file.division = 384)
         file.add_track(track)
         file_ref := "MThd%/0/%/0/%/0/%/6/%/0/%/1/%/0/%/1/%/1/%/128/" + track_ref

         track.encode_to(stream)
         assert_stream(track_ref)

         file.encode_to(stream)
         assert_stream(file_ref)

         -- that last sections allow to chack that the midi file is
         -- well formed (use Timidity++ or whatever to check)
         create bfw.connect_to("test.mid")
         if bfw.is_connected then
            file_ref.do_all(agent (c: CHARACTER; b: BINARY_FILE_WRITE) is do b.put_byte(c.code) end(?, bfw))
            bfw.disconnect
         end
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
