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
class MIXUP_MIDI_STAFF

inherit
   MIXUP_ABSTRACT_STAFF[MIXUP_MIDI_OUTPUT_STREAM,
                        MIXUP_MIDI_SECTION,
                        MIXUP_MIDI_ITEM,
                        MIXUP_MIDI_VOICE,
                        MIXUP_MIDI_VOICES
                        ]

create {ANY}
   make

feature {}
   generate_lyrics (lyr: AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]; index: INTEGER; context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION) is
      do
      end

   new_voices (a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]): like root_voices is
      do
         create Result.make(voice_ids, lyrics_gatherer)
      end

end -- class MIXUP_MIDI_STAFF
