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
   LOGGING

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

   duration: INTEGER_64
   reference: MIXUP_NOTE_HEAD
   allow_lyrics: BOOLEAN is True

   add_bar (style: FIXED_STRING) is
      do
         add_music(create {MIXUP_BAR}.make(style))
      end

   bars: ITERABLE[INTEGER_64] is
      local
         barset: AVL_SET[INTEGER_64]
      do
         create barset.make
         consolidate_bars(barset, 0)
         Result := barset
      end

   up_staff is
      do
         -- TODO
      end

   down_staff is
      do
         -- TODO
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

   add_chord (note_heads: COLLECTION[FIXED_STRING]; note_length: INTEGER_64) is
      local
         i: INTEGER
         ref: like reference
         chord: MIXUP_CHORD
      do
         from
            create chord.make(note_heads.count, note_length)
            ref := reference
            i := note_heads.lower
         until
            i > note_heads.upper
         loop
            ref := ref.relative(note_heads.item(i))
            chord.put(i - note_heads.lower, ref)
            i := i + 1
         end
         music.add_last(chord)
         duration := duration + chord.duration
         reference := chord.anchor
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      local
         aggregator: AGGREGATOR[MIXUP_MUSIC, INTEGER_64]
      do
         debug
            log.trace.put_line("Committing voice")
         end
         duration := aggregator.map(music, commit_agent(a_context, a_player), 0)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_EVENTS_ITERATOR_ON_VOICE} Result.make(a_context, music)
      end

feature {}
   commit_agent (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): FUNCTION[TUPLE[MIXUP_MUSIC, INTEGER_64], INTEGER_64] is
      do
         Result := agent (mus: MIXUP_MUSIC; dur: INTEGER_64; ctx: MIXUP_CONTEXT; plr: MIXUP_PLAYER): INTEGER_64 is
            do
               mus.commit(ctx, plr)
               Result := dur + mus.duration
            end (?, ?, a_context, a_player)
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
   make (a_reference: like reference) is
      do
         create {FAST_ARRAY[MIXUP_MUSIC]} music.make(0)
         reference := a_reference
      ensure
         reference = a_reference
      end

   music: COLLECTION[MIXUP_MUSIC]

invariant
   music /= Void

end -- class MIXUP_VOICE
