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
      rename
         make as make_abstract
      end

create {ANY}
   make

feature {}
   generate_lyrics (lyr: AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]; index: INTEGER; context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION) is
      do
      end

   new_voices (a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]): like root_voices is
      do
         create Result.make(voice_ids, lyrics_gatherer, track, track_id)
      end

   make (a_id: like id; a_voice_ids: TRAVERSABLE[INTEGER]; a_track: like track; a_track_id: like track_id) is
      require
         a_track /= Void
         a_track_id.in_range(0, 15)
      do
         track := a_track
         track_id := a_track_id
         make_abstract(a_id, a_voice_ids)
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

invariant
   track /= Void
   track_id.in_range(0, 15)

end -- class MIXUP_MIDI_STAFF
