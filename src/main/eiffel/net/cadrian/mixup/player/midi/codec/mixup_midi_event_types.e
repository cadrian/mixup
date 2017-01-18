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
deferred class MIXUP_MIDI_EVENT_TYPES

feature {ANY}
   event_channel_pressure:     INTEGER_8 is 0xd0
   event_controller:           INTEGER_8 is 0xb0
   event_key_pressure:         INTEGER_8 is 0xa0
   event_note_off:             INTEGER_8 is 0x80
   event_note_on:              INTEGER_8 is 0x90
   event_pitch_bend:           INTEGER_8 is 0xe0
   event_program_change:       INTEGER_8 is 0xc0

   event_meta_event:           INTEGER_8 is 0xff

   meta_event_sequence_number: INTEGER_8 is 0x00
   meta_event_text:            INTEGER_8 is 0x01
   meta_event_copyright:       INTEGER_8 is 0x02
   meta_event_track_name:      INTEGER_8 is 0x03
   meta_event_instrument_name: INTEGER_8 is 0x04
   meta_event_lyrics:          INTEGER_8 is 0x05
   meta_event_marker_text:     INTEGER_8 is 0x06
   meta_event_cue_point:       INTEGER_8 is 0x07
   meta_event_channel_prefix:  INTEGER_8 is 0x20
   meta_event_end_of_track:    INTEGER_8 is 0x2f
   meta_event_tempo_setting:   INTEGER_8 is 0x51
   meta_event_time_signature:  INTEGER_8 is 0x58
   meta_event_key_signature:   INTEGER_8 is 0x59

end -- class MIXUP_MIDI_EVENT_TYPES
