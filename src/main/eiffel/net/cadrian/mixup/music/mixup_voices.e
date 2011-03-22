-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_VOICES

inherit
   MIXUP_COMPOUND_MUSIC

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   duration: INTEGER_64

feature {ANY}
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

   add_chord (note_heads: COLLECTION[FIXED_STRING]; note_length: INTEGER_64) is
      do
         voices.last.add_chord(note_heads, note_length)
      end

   add_bar (style: FIXED_STRING) is
      do
         voices.last.add_bar(style)
      end

   up_staff is
      do
         voices.last.up_staff
      end

   down_staff is
      do
         voices.last.down_staff
      end

   next_voice is
      local
         voice: MIXUP_VOICE
      do
         create voice.make(reference_)
         voices.add_last(voice)
      ensure
         voices.count = old voices.count + 1
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      local
         durations: AVL_SET[INTEGER_64]
      do
         debug
            log.trace.put_line("Committing voices")
         end
         voices.do_all(commit_agent(a_context, a_player))
         debug
            log.trace.put_line("Checking voices bars")
         end
         create durations.make
         voices.do_all(agent (voice: MIXUP_VOICE; durations_set: SET[INTEGER_64]) is
                          do
                             if not voice.bars.is_equal(bars) then
                                not_yet_implemented -- error: bar durations mismatch
                             end
                             durations_set.add(voice.duration)
                          end (?, durations))
         if durations.count > 1 then
            not_yet_implemented -- error: all voices don't have the same duration
         end
         duration := durations.first
         debug
            log.trace.put_line("Voices duration = " + duration.out)
         end
      end

   bars: TRAVERSABLE[INTEGER_64] is
      do
         Result := voices.first.bars
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_EVENTS_ITERATOR_ON_VOICES} Result.make(a_context, voices)
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

feature {}
   make (a_reference: like reference_) is
      do
         create {FAST_ARRAY[MIXUP_VOICE]} voices.make(0)
         reference_ := a_reference
      ensure
         reference_ = a_reference
      end

   voices: COLLECTION[MIXUP_VOICE]
   reference_: MIXUP_NOTE_HEAD

   commit_agent (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): PROCEDURE[TUPLE[MIXUP_VOICE]] is
      do
         Result := agent {MIXUP_VOICE}.commit(a_context, a_player)
      end

end -- class MIXUP_VOICES
