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
class TEST_MIDI_FILE

insert
   MIXUP_MIDI_META_EVENTS
   MIXUP_MIDI_CONTROLLER_KNOBS

create {}
   make

feature {}
   make is
      local
         bfw: BINARY_FILE_WRITE
         stream: MIXUP_MIDI_FILE_WRITE
      do
         create bfw.connect_to("mixup.mid")
         if not bfw.is_connected then
            std_error.put_line("Could not open mixup.mid for writing")
            die_with_code(1)
         end
         create stream.connect_to(bfw)

         midi.encode_to(stream)

         stream.disconnect
      end

   midi: MIXUP_MIDI_FILE is
      local
         track1, track2, track3: MIXUP_MIDI_EVENTS
      do
         -- NOTE! track names of the first track are SEQUENCE names
         -- so don't use that first track for music.
         create track1.make
         track1.add_event(  0, track_name_event("MiXuP"))
         track1.add_event(  0, copyright_event("copyleft"))
         track1.add_event(256, text_event("some random text"))
         track1.add_event(512, end_of_track_event)

         create track2.make
         track2.add_event(  0, track_name_event("melody"))
         track2.add_event(  0, instrument_name_event("Piano"))
         track2.add_event(  0, create {MIXUP_MIDI_CONTROLLER}.make(0, bank_controller, 0))
         track2.add_event(  0, create {MIXUP_MIDI_CONTROLLER}.make(0, channel_volume_controller, 64))
         track2.add_event(  0, create {MIXUP_MIDI_PROGRAM_CHANGE}.make(0, 1)) -- bright piano
         track2.add_event(  0, lyrics_event("do "))
         track2.add_event(  0, create {MIXUP_MIDI_CONTROLLER}.make(0, expression_controller, 32))
         track2.add_event(  0, create {MIXUP_MIDI_NOTE_ON}.make(0, 60, 64))
         track2.add_event(256, create {MIXUP_MIDI_NOTE_OFF}.make(0, 60, 64))
         track2.add_event(128, lyrics_event("mi "))
         track2.add_event(128, create {MIXUP_MIDI_CONTROLLER}.make(0, expression_controller, 64))
         track2.add_event(128, create {MIXUP_MIDI_NOTE_ON}.make(0, 64, 64))
         track2.add_event(384, create {MIXUP_MIDI_NOTE_OFF}.make(0, 64, 64))
         track2.add_event(256, lyrics_event("sol%N"))
         track2.add_event(256, create {MIXUP_MIDI_CONTROLLER}.make(0, expression_controller, 127))
         track2.add_event(256, create {MIXUP_MIDI_NOTE_ON}.make(0, 67, 64))
         track2.add_event(512, create {MIXUP_MIDI_NOTE_OFF}.make(0, 67, 64))
         track2.add_event(512, end_of_track_event)

         create track3.make
         track3.add_event(  0, track_name_event("continuo"))
         track3.add_event(  0, instrument_name_event("Cello"))
         track3.add_event(  0, create {MIXUP_MIDI_CONTROLLER}.make(1, bank_controller, 0))
         track3.add_event(  0, create {MIXUP_MIDI_CONTROLLER}.make(1, channel_volume_controller, 64))
         track3.add_event(  0, create {MIXUP_MIDI_PROGRAM_CHANGE}.make(1, 42)) -- cello
         track3.add_event(  0, create {MIXUP_MIDI_CONTROLLER}.make(1, expression_controller,  48))
         track3.add_event(128, create {MIXUP_MIDI_CONTROLLER}.make(1, expression_controller,  64))
         track3.add_event(256, create {MIXUP_MIDI_CONTROLLER}.make(1, expression_controller,  80))
         track3.add_event(384, create {MIXUP_MIDI_CONTROLLER}.make(1, expression_controller,  96))
         track3.add_event(512, create {MIXUP_MIDI_CONTROLLER}.make(1, expression_controller, 112))
         track3.add_event(  0, create {MIXUP_MIDI_NOTE_ON}.make(1, 48, 64))
         track3.add_event(512, create {MIXUP_MIDI_NOTE_OFF}.make(1, 48, 64))
         track3.add_event(512, end_of_track_event)

         create Result.make(192)
         Result.add_track(track1)
         Result.add_track(track2)
         Result.add_track(track3)
      end

end -- class TEST_MIDI_FILE
