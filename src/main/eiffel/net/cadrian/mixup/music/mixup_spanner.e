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
deferred class MIXUP_SPANNER
   --
   -- Horizontal music.
   --

insert
   MIXUP_ERRORS
      undefine
         out_in_tagged_out_memory
      end

feature {ANY}
   id: INTEGER
   timing: MIXUP_MUSIC_TIMING

   duration: INTEGER_64 is
      deferred
      end

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

   reference: MIXUP_NOTE_HEAD
   allow_lyrics: BOOLEAN is True

   add_bar (a_source: MIXUP_SOURCE; style: FIXED_STRING) is
      require
         a_source /= Void
      do
         add_music(create {MIXUP_BAR}.make(a_source, style))
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
         from
            create chord.make(a_source, note_heads.count, note_length, tie)
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

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current is
      local
         music_: FAST_ARRAY[MIXUP_MUSIC]
         music_zip: AGGREGATOR[MIXUP_MUSIC, MIXUP_MUSIC_TIMING]
         timing_: MIXUP_MUSIC_TIMING
      do
         create music_.make(music.count)
         timing_ := music_zip.map_index(music,
                                        agent (music0: MIXUP_MUSIC; a_music: FAST_ARRAY[MIXUP_MUSIC]; accu: MIXUP_MUSIC_TIMING; commit_context_: MIXUP_COMMIT_CONTEXT; index: INTEGER): MIXUP_MUSIC_TIMING is
                                        local
                                           music0_: MIXUP_MUSIC
                                        do
                                           log.trace.put_string(once "COMMIT: span: bar number is ")
                                           log.trace.put_integer(accu.first_bar_number + accu.bars_count)
                                           log.trace.put_new_line
                                           commit_context_.set_bar_number(accu.first_bar_number + accu.bars_count)
                                           music0_ := music0.commit(commit_context_)
                                           Result := accu + music0_.timing
                                           a_music.put(music0_, index)
                                        end(?, music_, ?, a_commit_context, ?),
                                        timing_.set(0, a_commit_context.bar_number, 0))
         Result := do_duplicate(music_, timing_)
      ensure
         Result.timing.is_set
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
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

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         timing := timing.set(a_duration, a_first_bar_number, a_bars_count)
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

   do_duplicate (a_music: like music; a_timing: like timing): like Current is
      require
         a_music /= Void
         a_timing.is_set
      deferred
      ensure
         Result /= Void
         Result /= Current
         Result.source = source
         Result.reference = reference
         Result.id = id
         Result.timing.is_set
         Result.timing = a_timing
         --Result.music = a_music
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

end -- class MIXUP_SPANNER
