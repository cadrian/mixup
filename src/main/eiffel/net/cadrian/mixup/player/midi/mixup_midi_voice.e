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

feature {ANY}
   dynamics: MIXUP_MIDI_DYNAMICS

feature {MIXUP_ABSTRACT_STAFF}
   add_item (a_item: MIXUP_MIDI_ITEM)
      do
         items.add_last(a_item)
      end

   set_dynamics (a_dynamics, position: ABSTRACT_STRING; is_standard: BOOLEAN)
      do
         inspect
            a_dynamics.intern
         when "ppp", "pp", "p", "mp", "mf", "f", "ff", "fff", "end" then
            create {MIXUP_MIDI_DYNAMICS_NUANCE} dynamics.make(dynamics, a_dynamics)
         when "<", ">", "cresc", "decr", "dim" then
            create {MIXUP_MIDI_DYNAMICS_HAIRPIN} dynamics.make(dynamics)
         else
            -- ignored for now
         end
      end

   set_note (a_time: INTEGER_64; a_note: MIXUP_NOTE)
      local
         note: MIXUP_MIDI_NOTE
      do
         create note.make(a_time, a_note, track, track_id, slur_numerator, slur_denominator, dynamics)
         add_item(note)
         last_note := note
      end

   next_bar (style: ABSTRACT_STRING)
      do
      end

   skip_octave (a_time: INTEGER_64; skip: INTEGER_8)
      do
         track.add_event(a_time, create {MIXUP_MIDI_TRANSPOSE_EVENT}.make(12 * skip))
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         fix_slur(11, 12)
      end

   end_beam
      do
         fix_slur(7, 8)
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         fix_slur(1, 1)
      end

   end_slur
      do
         fix_slur(7, 8)
      end

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         fix_slur(1, 1)
      end

   end_phrasing_slur
      do
         fix_slur(7, 8)
      end

   start_repeat (volte: INTEGER_64)
      do
      end

   end_repeat
      do
      end

feature {MIXUP_MIDI_STAFF}
   send_events (a_time: INTEGER_64; a_events: HOARD[FUNCTION[TUPLE[INTEGER_8], MIXUP_MIDI_EVENT]])
      require
         a_events /= Void
      do
         add_item(create {MIXUP_MIDI_EVENTS_TO_SEND}.make(a_time, a_events, track, track_id))
      end

feature {} -- TODO: remove the lyrics_gatherer which is lilypond-specific
   make (a_id: like id; a_lyrics_gatherer: like lyrics_gatherer; a_track: like track; a_track_id: like track_id; a_dynamics: like dynamics)
      require
         a_track /= Void
         a_track_id.in_range(0, 15)
         a_dynamics /= Void
      do
         fix_slur(7, 8)
         track := a_track
         track_id := a_track_id
         dynamics := a_dynamics
         make_abstract(a_id, a_lyrics_gatherer)
      ensure
         track = a_track
         track_id = a_track_id
         dynamics = a_dynamics
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

   last_note: MIXUP_MIDI_NOTE

   slur_numerator, slur_denominator: INTEGER

   fix_slur (a_slur_numerator, a_slur_denominator: INTEGER)
      require
         a_slur_numerator > 0
         a_slur_denominator > 0
      do
         slur_numerator := a_slur_numerator
         slur_denominator := a_slur_denominator
         if last_note /= Void then
            last_note.fix_slur(a_slur_numerator, a_slur_denominator)
         end
      end

invariant
   track /= Void
   track_id.in_range(0, 15)
   dynamics /= Void

end -- class MIXUP_MIDI_VOICE
