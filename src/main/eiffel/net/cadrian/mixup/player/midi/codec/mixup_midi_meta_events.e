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
expanded class MIXUP_MIDI_META_EVENTS

insert
   LOGGING
   MIXUP_MIDI_EVENT_TYPES

feature {ANY}
   end_of_track_event: MIXUP_MIDI_META_EVENT is
         -- must always be added, and added last, to each track
      once
         create Result.make(meta_event_end_of_track, "", "end_of_track_event")
      end

   sequence_number_event (sequence_number: INTEGER_32): MIXUP_MIDI_META_EVENT is
      require
         sequence_number.in_range(0, 0x0000ffff)
      local
         bytes: STRING; int: INTEGER_8
      do
         create bytes.make_filled('%U', 2)
         int := (sequence_number |>> 8).to_integer_8
         bytes.put(int.to_character, 0)
         int := (sequence_number & 0x000000ff).to_integer_8
         bytes.put(int.to_character, 1)
         create Result.make(meta_event_sequence_number, bytes, "sequence_number_event")
      end

   text_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_text, a_text, "text_event: '" + a_text + "'")
      end

   copyright_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_copyright, a_text, "copyright_event: '" + a_text + "'")
      end

   track_name_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_track_name, a_text, "track_name_event: '" + a_text + "'")
      end

   instrument_name_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_instrument_name, a_text, "instrument_name_event: '" + a_text + "'")
      end

   lyrics_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_lyrics, a_text, "lyrics_event: '" + a_text + "'")
      end

   marker_text_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_marker_text, a_text, "marker_text_event: '" + a_text + "'")
      end

   cue_point_event (a_text: ABSTRACT_STRING): MIXUP_MIDI_META_EVENT is
      require
         a_text /= Void
      do
         create Result.make(meta_event_cue_point, a_text, "copyright_event: '" + a_text + "'")
      end

   tempo_setting_event (bpm: INTEGER): MIXUP_MIDI_META_EVENT is
      require
         bpm.in_range(1, 0x00003fff)
      local
         setting: STRING; mpq: INTEGER
      do
         setting := ""
         mpq := bpm_to_mpq(bpm)
         setting.extend(((mpq|>>16) & 0x000000ff).to_character)
         setting.extend(((mpq|>> 8) & 0x000000ff).to_character)
         setting.extend(((mpq     ) & 0x000000ff).to_character)
         create Result.make(meta_event_tempo_setting, setting, "tempo_setting_event: " + bpm.out + " BPM")
      end

feature {}
   bpm_to_mpq (bpm: INTEGER): INTEGER is
         -- Bytes Per Minute => Microseconds Per Quarter
      do
         Result := 60000000 // bpm;
         log.info.put_line(bpm.out + " BPM => " + Result.out + " MPQ")
      end

feature {ANY}
   valid_code (a_code: INTEGER_32): BOOLEAN is
      do
         Result := valid_codes.has(a_code)
      end

feature {}
   valid_codes: AVL_SET[INTEGER_32] is
      once
         create Result.make
         Result.add(meta_event_sequence_number )
         Result.add(meta_event_text            )
         Result.add(meta_event_copyright       )
         Result.add(meta_event_track_name      )
         Result.add(meta_event_instrument_name )
         Result.add(meta_event_lyrics          )
         Result.add(meta_event_marker_text     )
         Result.add(meta_event_cue_point       )
         Result.add(meta_event_channel_prefix  )
         Result.add(meta_event_end_of_track    )
         Result.add(meta_event_tempo_setting   )
         Result.add(meta_event_time_signature  )
         Result.add(meta_event_key_signature   )
      end

end -- class MIXUP_MIDI_META_EVENTS
