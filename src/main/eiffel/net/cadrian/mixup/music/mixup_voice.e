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
class MIXUP_VOICE

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   valid_anchor: BOOLEAN is True

   anchor: MIXUP_NOTE_HEAD is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := music.lower
         until
            found or else i > music.upper
         loop
            if music.item(i).valid_anchor then
               Result := music.item(i).anchor
               found := True
            end
            i := i + 1
         end
         if not found then
            Result := reference
         end
      end

   staff: INTEGER
   duration: INTEGER_64
   reference: MIXUP_NOTE_HEAD
   allow_lyrics: BOOLEAN is True

   add_bar (a_source: MIXUP_SOURCE; style: FIXED_STRING) is
      require
         a_source /= Void
      do
         add_music(create {MIXUP_BAR}.make(a_source, style))
      end

   bars: ITERABLE[INTEGER_64] is
      local
         barset: AVL_SET[INTEGER_64]
      do
         create barset.make
         consolidate_bars(barset, 0)
         Result := barset
      end

   add_music (a_music: MIXUP_MUSIC) is
      require
         a_music /= Void
      do
         debug
            log.trace.put_line("Adding music: " + a_music.out)
         end
         music.add_last(a_music)
         if a_music.valid_anchor then
            reference := a_music.anchor
         end
      ensure
         music.last = a_music
      end

   add_chord (a_source: MIXUP_SOURCE; note_heads: COLLECTION[TUPLE[MIXUP_SOURCE, FIXED_STRING]]; note_length: INTEGER_64; tie: BOOLEAN) is
      require
         a_source /= Void
      local
         i: INTEGER
         ref, note: MIXUP_NOTE_HEAD
         chord: MIXUP_CHORD
      do
         -- TODO: manage tie
         from
            create chord.make(a_source, note_heads.count, note_length)
            ref := reference
            i := note_heads.lower
         until
            i > note_heads.upper
         loop
            note := ref.relative(note_heads.item(i).first, note_heads.item(i).second)
            chord.put(i - note_heads.lower, note)
            if not note.is_rest then
               ref := note
            end
            i := i + 1
         end
         music.add_last(chord)
         if not chord.anchor.is_rest then
            reference := chord.anchor
         end
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      local
         bar_counter: AGGREGATOR[MIXUP_MUSIC, INTEGER]
         aggregator: AGGREGATOR[MIXUP_MUSIC, INTEGER_64]
      do
         debug
            log.trace.put_line("Committing voice")
         end
         Result := bar_counter.map(music, commit_agent(a_context, a_player, start_bar_number), start_bar_number)
         duration := aggregator.map(music, duration_agent(a_context, a_player), 0)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_EVENTS_ITERATOR_ON_VOICE} Result.make(a_context, music)
      end

   set_staff_id (a_staff_id: INTEGER) is
      do
         music.do_all(agent {MIXUP_MUSIC}.set_staff_id(a_staff_id))
      end

feature {}
   commit_agent (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): FUNCTION[TUPLE[MIXUP_MUSIC, INTEGER], INTEGER] is
      do
         Result := agent (mus: MIXUP_MUSIC; ctx: MIXUP_CONTEXT; plr: MIXUP_PLAYER; start, max: INTEGER): INTEGER is
            do
               Result := mus.commit(ctx, plr, start).max(max)
            end (?, a_context, a_player, start_bar_number, ?)
      end

   duration_agent (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): FUNCTION[TUPLE[MIXUP_MUSIC, INTEGER_64], INTEGER_64] is
      do
         Result := agent (mus: MIXUP_MUSIC; dur: INTEGER_64): INTEGER_64 is
            do
               Result := dur + mus.duration
            end
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (barset: SET[INTEGER_64]; duration_offset: like duration) is
      local
         d: like duration
         i: INTEGER
      do
         from
            i := music.lower
         until
            i > music.upper
         loop
            music.item(i).consolidate_bars(barset, d)
            d := d + music.item(i).duration
            i := i + 1
         end
         check
            d = duration
         end
      end

feature {}
   make (a_source: like source; a_reference: like reference) is
      require
         a_source /= Void
         not a_reference.is_rest
      do
         source := a_source
         create {FAST_ARRAY[MIXUP_MUSIC]} music.make(0)
         reference := a_reference
      ensure
         source = a_source
         reference = a_reference
      end

   music: COLLECTION[MIXUP_MUSIC]

invariant
   music /= Void
   not reference.is_rest

end -- class MIXUP_VOICE
