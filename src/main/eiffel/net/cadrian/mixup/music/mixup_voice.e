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
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   id: INTEGER

   valid_anchor: BOOLEAN is True

   anchor: MIXUP_NOTE_HEAD is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := music.upper
         until
            found or else i < music.lower
         loop
            found := music.item(i).valid_anchor
            if found then
               Result := music.item(i).anchor
            end
            i := i - 1
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
            log.trace.put_line("Voice #" + id.out + ": adding music: " + a_music.out)
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
         debug
            log.trace.put_line("Voice #" + id.out + ": adding chord: " + chord.out)
         end
         music.add_last(chord)
         if chord.valid_anchor then
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
         a_context.set_voice_id(id)
         create {MIXUP_EVENTS_ITERATOR_ON_VOICE} Result.make(a_context, music)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.extend('<')
         tagged_out_memory.extend('#')
         id.append_in(tagged_out_memory)
         music.do_all(agent (mus: MIXUP_MUSIC) is
                         do
                            tagged_out_memory.extend(' ')
                            mus.out_in_tagged_out_memory
                         end)
         tagged_out_memory.extend('>')
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

   add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
         if not ids.fast_has(id) then
            ids.add(id)
            music.do_all(agent (a_music: MIXUP_MUSIC; a_ids: AVL_SET[INTEGER]) is
                            do
                               a_music.add_voice_ids(a_ids)
                            end(?, ids))
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
         id_provider.next
         id := id_provider.item
      ensure
         source = a_source
         reference = a_reference
      end

   music: COLLECTION[MIXUP_MUSIC]

   id_provider: COUNTER is
      once
         create Result
      end

invariant
   music /= Void
   not reference.is_rest
   id > 0

end -- class MIXUP_VOICE
