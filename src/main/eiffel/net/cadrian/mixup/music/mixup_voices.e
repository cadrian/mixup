class MIXUP_VOICES

inherit
   MIXUP_COMPOUND_MUSIC

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

   add_bar is
      do
         voices.last.add_bar
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

   commit (a_context: MIXUP_CONTEXT) is
      local
         durations: AVL_SET[INTEGER_64]
      do
         voices.do_all(commit_agent(a_context))
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
      end

   bars: TRAVERSABLE[INTEGER_64] is
      do
         Result := voices.first.bars
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_NOTES_ITERATOR_ON_VOICES} Result.make(a_context, voices)
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars_: SET[INTEGER_64]; duration_offset: like duration) is
      do
         voices.first.consolidate_bars(bars_, duration_offset)
      end

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

   commit_agent (a_context: MIXUP_CONTEXT): PROCEDURE[TUPLE[MIXUP_VOICE]] is
      do
         Result := agent {MIXUP_VOICE}.commit(a_context)
      end

end
