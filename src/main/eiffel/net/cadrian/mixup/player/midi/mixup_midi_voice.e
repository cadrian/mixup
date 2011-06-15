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
class MIXUP_MIDI_VOICE

inherit
   MIXUP_ABSTRACT_VOICE[MIXUP_MIDI_OUTPUT_STREAM,
                        MIXUP_MIDI_SECTION,
                        MIXUP_MIDI_ITEM
                        ]
      rename
         make as make_abstract
      end

create {ANY}
   make

feature {MIXUP_ABSTRACT_STAFF}
   add_item (a_item: MIXUP_MIDI_ITEM) is
      do
         items.add_last(a_item)
      end

   set_dynamics (a_dynamics, position: ABSTRACT_STRING) is
      do
      end

   set_note (a_time: INTEGER_64; a_note: MIXUP_NOTE) is
      local
         note: MIXUP_MIDI_NOTE
      do
         create note.make(a_time, a_note, track, track_id)
         add_item(note)
      end

   next_bar (style: ABSTRACT_STRING) is
      do
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_beam is
      do
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_slur is
      do
      end

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_phrasing_slur is
      do
      end

   start_repeat (volte: INTEGER_64) is
      do
      end

   end_repeat is
      do
      end

feature {} -- TODO: remove the lyrics_gatherer which is lilypond-specific
   make (a_id: like id; a_lyrics_gatherer: like lyrics_gatherer; a_track: like track; a_track_id: like track_id) is
      require
         a_track /= Void
         a_track_id.in_range(0, 15)
      do
         track := a_track
         track_id := a_track_id
         make_abstract(a_id, a_lyrics_gatherer)
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

invariant
   track /= Void
   track_id.in_range(0, 15)

end -- class MIXUP_MIDI_VOICE
