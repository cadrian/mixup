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
class MIXUP_MIDI_VOICES

inherit
   MIXUP_MIDI_ITEM
   MIXUP_ABSTRACT_VOICES[MIXUP_MIDI_OUTPUT_STREAM,
                         MIXUP_MIDI_SECTION,
                         MIXUP_MIDI_ITEM,
                         MIXUP_MIDI_VOICE
                         ]
      rename
         make as make_abstract
      end

create {ANY}
   make

feature {}
   make (a_ids: TRAVERSABLE[INTEGER]; a_lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]; a_track: like track; a_track_id: like track_id) is
      require
         a_track /= Void
         a_track_id.in_range(0, 15)
      do
         track := a_track
         track_id := a_track_id
         make_abstract(a_ids, a_lyrics_gatherer)
      end

   new_voice (a_id: INTEGER; lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]): MIXUP_MIDI_VOICE is
      do
         create Result.make(a_id, lyrics_gatherer, track, track_id)
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

invariant
   track /= Void
   track_id.in_range(0, 15)

end -- class MIXUP_MIDI_VOICES