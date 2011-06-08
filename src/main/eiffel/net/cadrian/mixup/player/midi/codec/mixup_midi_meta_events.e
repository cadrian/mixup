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

feature {ANY}
   valid_code (a_code: INTEGER_8): BOOLEAN is
      do
         Result := valid_codes.fast_has(a_code)
      end

   sequence_number: INTEGER_8 is 0x00
   text:            INTEGER_8 is 0x01
   copyright:       INTEGER_8 is 0x02
   track_name:      INTEGER_8 is 0x03
   instrument_name: INTEGER_8 is 0x04
   lyrics:          INTEGER_8 is 0x05
   marker_text:     INTEGER_8 is 0x06
   cue_point:       INTEGER_8 is 0x07

   channel_prefix:  INTEGER_8 is 0x20
   end_of_track:    INTEGER_8 is 0x2f

   tempo_setting:   INTEGER_8 is 0x51
   time_signature:  INTEGER_8 is 0x58
   key_signature:   INTEGER_8 is 0x59

feature {}
   valid_codes: AVL_SET[INTEGER_8] is
      once
         create Result.make
         Result.add(sequence_number )
         Result.add(text            )
         Result.add(copyright       )
         Result.add(track_name      )
         Result.add(instrument_name )
         Result.add(lyrics          )
         Result.add(marker_text     )
         Result.add(cue_point       )
         Result.add(channel_prefix  )
         Result.add(end_of_track    )
         Result.add(tempo_setting   )
         Result.add(time_signature  )
         Result.add(key_signature   )
      end

end -- class MIXUP_MIDI_META_EVENTS
