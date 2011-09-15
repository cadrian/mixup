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

create {MIXUP_VOICES}
   duplicate

feature {ANY}
   timing: MIXUP_MUSIC_TIMING is
      do
         Result := voices.first.timing
      end

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
            found := voices.item(i).valid_anchor
            if found then
               Result := voices.item(i).anchor
            end
            i := i + 1
         end
         if not found then
            Result := reference
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

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current is
      local
         timings: AVL_SET[MIXUP_MUSIC_TIMING]
         voices_: like voices
         voices_zip: ZIP[MIXUP_VOICE, INTEGER]
      do
         create timings.make
         create voices_.make(voices.count)
         create voices_zip.make(voices, voices_.lower |..| voices_.upper)
         voices_zip.do_all(agent (voice: MIXUP_VOICE; index: INTEGER; a_voices: like voices; commit_context_: MIXUP_COMMIT_CONTEXT; timings_set: SET[MIXUP_MUSIC_TIMING]) is
                           local
                              voice_: MIXUP_VOICE
                           do
                              voice_ := voice.commit(commit_context_)
                              a_voices.put(voice_, index)
                              timings_set.add(voice_.timing)
                           end (?, ?, voices_, a_commit_context, timings))
         if timings.count > 1 then
            voices_.do_all(agent (voice: MIXUP_VOICE) is
                           do
                              warning_at(voice.source, "timing: " + voice.timing.out + " " + voice.out)
                           end)
            warning("all voices don't have the same timing (details above)")
         end
         debug
            log.trace.put_line(once "Voices duration = " | &duration)
         end
         create Result.duplicate(source, reference_, voices_)
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

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         voices.do_all(agent {MIXUP_VOICE}.set_timing(a_duration, a_first_bar_number, a_bars_count))
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
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

   duplicate (a_source: like source; a_reference: like reference_; a_voices: like voices) is
      require
         not a_voices.is_empty
         a_voices.first.timing.is_set
      do
         source := a_source
         voices := a_voices
         reference_ := a_reference
      ensure
         source = a_source
         voices = a_voices
         reference_ = a_reference
      end

   voices: FAST_ARRAY[MIXUP_VOICE]
   reference_: MIXUP_NOTE_HEAD

invariant
   voices /= Void

end -- class MIXUP_VOICES
