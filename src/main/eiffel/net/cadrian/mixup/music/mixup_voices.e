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
class MIXUP_VOICES

inherit
   MIXUP_COMPOUND_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   duration: INTEGER_64

feature {ANY}
   staff_count: INTEGER

   anchor: MIXUP_NOTE_HEAD is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := voices.lower
         until
            found or else i > voices.upper
         loop
            if voices.item(i).valid_anchor then
               Result := voices.item(i).anchor
               found := True
            end
            i := i + 1
         end
         if not found then
            Result := reference_
         end
      end

   reference: MIXUP_NOTE_HEAD is
      do
         if voices.is_empty then
            Result := reference_
         else
            Result := voices.last.reference
         end
      end

   add_music (a_music: MIXUP_MUSIC) is
      do
         voices.last.add_music(a_music)
      end

   add_chord (a_source: like source; note_heads: COLLECTION[TUPLE[MIXUP_SOURCE, FIXED_STRING]]; note_length: INTEGER_64; tie: BOOLEAN) is
      do
         voices.last.add_chord(a_source, note_heads, note_length, tie)
      end

   add_bar (a_source: like source; style: FIXED_STRING) is
      do
         voices.last.add_bar(a_source, style)
      end

   next_voice (a_source: MIXUP_SOURCE) is
      require
         a_source /= Void
      local
         voice: MIXUP_VOICE
      do
         create voice.make(a_source, reference_)
         voices.add_last(voice)
      ensure
         voices.count = old voices.count + 1
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      local
         durations: AVL_SET[INTEGER_64]
         bar_counter: AGGREGATOR[MIXUP_VOICE, INTEGER]
      do
         debug
            log.trace.put_line("Committing voices")
         end
         Result := bar_counter.map(voices, commit_agent(a_context, a_player, start_bar_number), start_bar_number)
         debug
            log.trace.put_line("Checking voices bars")
         end
         create durations.make
         voices.do_all(agent (voice: MIXUP_VOICE; durations_set: SET[INTEGER_64]) is
                          do
                             if not voice.bars.is_equal(bars) then
                                warning_at(voice.source, "bar durations mismatch")
                             end
                             durations_set.add(voice.duration)
                          end (?, durations))
         if durations.count > 1 then
            voices.do_all(agent (voice: MIXUP_VOICE; durations_set: SET[INTEGER_64]) is
                             do
                                warning_at(voice.source, "duration = " + voice.duration.out + " " + voice.out)
                             end (?, durations))
            warning("all voices don't have the same duration (details above)")
         end
         duration := durations.first
         debug
            log.trace.put_line("Voices duration = " + duration.out)
         end
      end

   bars: ITERABLE[INTEGER_64] is
      do
         Result := voices.first.bars
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_EVENTS_ITERATOR_ON_VOICES} Result.make(source, a_context, voices)
      end

   voice_ids: TRAVERSABLE[INTEGER] is
      local
         ids: AVL_SET[INTEGER]
      do
         create ids.make
         Result := ids
         add_voice_ids(ids)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "<<")
         voices.do_all(agent (v: MIXUP_VOICE) is do tagged_out_memory.extend(' '); v.out_in_tagged_out_memory end)
         tagged_out_memory.append(once " >>")
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars_: SET[INTEGER_64]; duration_offset: like duration) is
      do
         if consolidating then
            sedb_breakpoint
         end
         consolidating := True
         voices.first.consolidate_bars(bars_, duration_offset)
         consolidating := False
      end

   consolidating: BOOLEAN

   add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
         voices.do_all(agent (a_voice: MIXUP_VOICE; a_ids: AVL_SET[INTEGER]) is
                          do
                             a_voice.add_voice_ids(a_ids)
                          end(?, ids))
      end

feature {}
   make (a_source: like source; a_reference: like reference_) is
      require
         a_source /= Void
      do
         source := a_source
         create voices.make(0)
         reference_ := a_reference
      ensure
         source = a_source
         reference_ = a_reference
      end

   voices: FAST_ARRAY[MIXUP_VOICE]
   reference_: MIXUP_NOTE_HEAD

   commit_agent (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): FUNCTION[TUPLE[MIXUP_VOICE, INTEGER], INTEGER] is
      do
         Result := agent commit_voice(a_context, a_player, start_bar_number, ?, ?)
      end

   commit_voice (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER; a_voice: MIXUP_VOICE; bar_number: INTEGER): INTEGER is
      do
         Result := a_voice.commit(a_context, a_player, start_bar_number).max(bar_number)
      end

invariant
   voices /= Void

end -- class MIXUP_VOICES
