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
class TEST_MIDI_PLAYER

insert
   EIFFELTEST_TOOLS
   MIXUP_NOTE_DURATIONS
   LOGGING

   MIXUP_MIDI_EVENTS
   MIXUP_MIDI_META_EVENTS
   MIXUP_MIDI_CONTROLLER_KNOBS

create {}
   make

feature {}
   source: AUX_MIXUP_MOCK_SOURCE

   note (a_note: STRING; a_octave: INTEGER): MIXUP_NOTE_HEAD is
      do
         Result.set(source, a_note, a_octave)
      end

   map (staff: INTEGER; voices: TRAVERSABLE[INTEGER]): MAP[TRAVERSABLE[INTEGER], INTEGER] is
      local
         ids: AVL_DICTIONARY[TRAVERSABLE[INTEGER], INTEGER]
      do
         create ids.make
         ids.add(create {AVL_SET[INTEGER]}.from_collection(voices), staff)
         Result := ids
      end

   my_instrument: MIXUP_INSTRUMENT

   event_data (time: INTEGER_64; staff_id, voice_id: INTEGER): MIXUP_EVENT_DATA is
      do
         Result.set(source, time, my_instrument, staff_id, voice_id)
      end

   make is
      local
         midi: MIXUP_MIDI_PLAYER
         buffer: AUX_MIXUP_MOCK_MIDI_OUTPUT
         context: AUX_MIXUP_MOCK_CONTEXT

         expected, actual: STRING
      do
         create source.make
         create my_instrument.make(source, "MyInstr", Void)

         create buffer.make
         create midi.connect_to(buffer)
         create context.make(source, "test context", Void)
         midi.set_context(context)

         midi.play_set_partitur  ("test"                                                                                                                 )
         midi.play_set_instrument(my_instrument.name, map(1, 1|..|2)                                                                                     )
         midi.play_transpose     (event_data(  0, 1, 0), 12                                                                                              )
         midi.play_start_voices  (event_data(  0, 1, 0), 1|..|1                                                                                          )
         midi.play_set_note      (event_data(  0, 1, 1), {MIXUP_LYRICS {MIXUP_CHORD duration_4, source, << note("c", 4) >> }, source, << "doe", "do" >> })
         midi.play_set_note      (event_data( 64, 1, 1), {MIXUP_LYRICS {MIXUP_CHORD duration_4, source, << note("d", 4) >> }, source, << "ray", "re" >> })
         midi.play_start_voices  (event_data(  0, 1, 1), 2|..|2                                                                                          )
         midi.play_set_note      (event_data(128, 1, 1), {MIXUP_LYRICS {MIXUP_CHORD duration_4, source, << note("e", 4) >> }, source, << "me" , "mi" >> })
         midi.play_end_voices    (event_data(192, 1, 1)                                                                                                  )
         midi.play_end_voices    (event_data(192, 1, 0)                                                                                                  )
         midi.play_end_partitur

         expected := expected_stream
         actual := buffer.to_string

         log.info.put_line(actual)
         assert(actual.is_equal(expected))
      end

   expected_stream: STRING is
      local
         file: MIXUP_MIDI_FILE
         track0, track1: MIXUP_MIDI_TRACK
         stream: AUX_MIXUP_MOCK_MIDI_OUTPUT

         start0, start1, start2, end0, end1, end2, delta: INTEGER
      do
         create file.make(768)
         create track0.make
         create track1.make
         file.add_track(track0)
         file.add_track(track1)

         delta := 64 * 12 * 7 // 8
         start0 :=   0      ; end0 := start0 + delta
         start1 :=  64 * 12 ; end1 := start1 + delta
         start2 := 128 * 12 ; end2 := start2 + delta

         track0.add_event(start0, track_name_event("partitur: test"))
         track0.add_event(  end2, end_of_track_event)

         track1.add_event(start0, track_name_event("MyInstr"))
         track1.add_event(start0, note_event(0, True,  60, 64))
         track1.add_event(start0, lyrics_event(" doe"))
         track1.add_event(start0, lyrics_event(" do"))
         track1.add_event(start0, controller_event(0, expression_controller, 64))

         track1.add_event(  end0, note_event(0, False, 60, 64))

         track1.add_event(start1, note_event(0, True,  62, 64))
         track1.add_event(start1, lyrics_event(" ray"))
         track1.add_event(start1, lyrics_event(" re"))

         track1.add_event(  end1, note_event(0, False, 62, 64))

         track1.add_event(start2, note_event(0, True,  64, 64))
         track1.add_event(start2, lyrics_event(" me"))
         track1.add_event(start2, lyrics_event(" mi"))

         track1.add_event(  end2, note_event(0, False, 64, 64))
         track1.add_event(  end2, end_of_track_event)

         create stream.make
         file.encode_to(stream)
         Result := ""
         stream.append_in(Result)
      end

end -- class TEST_MIDI_PLAYER
