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
   event_channel_pressure:     INTEGER_32 is 0x000000d0
   event_controller:           INTEGER_32 is 0x000000b0
   event_key_pressure:         INTEGER_32 is 0x000000a0
   event_note_off:             INTEGER_32 is 0x00000080
   event_note_on:              INTEGER_32 is 0x00000090
   event_pitch_bend:           INTEGER_32 is 0x000000e0
   event_program_change:       INTEGER_32 is 0x000000c0

   event_meta_event:           INTEGER_32 is 0x000000ff

   meta_event_sequence_number: INTEGER_32 is 0x00000000
   meta_event_text:            INTEGER_32 is 0x00000001
   meta_event_copyright:       INTEGER_32 is 0x00000002
   meta_event_track_name:      INTEGER_32 is 0x00000003
   meta_event_instrument_name: INTEGER_32 is 0x00000004
   meta_event_lyrics:          INTEGER_32 is 0x00000005
   meta_event_marker_text:     INTEGER_32 is 0x00000006
   meta_event_cue_point:       INTEGER_32 is 0x00000007
   meta_event_channel_prefix:  INTEGER_32 is 0x00000020
   meta_event_end_of_track:    INTEGER_32 is 0x0000002f
   meta_event_tempo_setting:   INTEGER_32 is 0x00000051
   meta_event_time_signature:  INTEGER_32 is 0x00000058
   meta_event_key_signature:   INTEGER_32 is 0x00000059

end -- class MIXUP_MIDI_EVENT_TYPES
