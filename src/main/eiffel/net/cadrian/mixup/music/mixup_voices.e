class MIXUP_VOICES

inherit
   MIXUP_COMPOUND_MUSIC

create {ANY}
   make

feature {ANY}
   duration: INTEGER_64

feature {ANY}
   anchor: MIXUP_NOTE_HEAD is
      do
         if voices.is_empty then
            Result := reference_
         else
            Result := voices.first.anchor
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

   add_chord (note_heads: COLLECTION[STRING]; note_length: INTEGER_64) is
      do
         voices.last.add_chord(note_heads, note_length)
      end

   next_bar is
      do
         voices.last.next_bar
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

   commit is
      local
         durations: AVL_SET[INTEGER_64]
         voice_bars: TRAVERSABLE[INTEGER_64]
         i: INTEGER
      do
         create durations.make
         voice_bars := bars
         from
            i := voices.lower
         until
            i > voices.upper
         loop
            voices.item(i).commit
            if not voices.item(i).bars.is_equal(voice_bars) then
               not_yet_implemented -- error: bar durations mismatch
            end
            durations.add(voices.item(i).duration)
            i := i + 1
         end
         if durations.count > 1 then
            not_yet_implemented -- error: all voices don't have the same duration
         end
         duration := durations.first
      end

   bars: TRAVERSABLE[INTEGER_64] is
      do
         Result := voices.first.bars
      end

   new_note_iterator (a_instrument: FIXED_STRING): MIXUP_NOTES_ITERATOR is
      do
         create {MIXUP_NOTES_ITERATOR_ON_VOICES} Result.make(a_instrument, voices)
      end

feature {MIXUP_VOICE}
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

end
