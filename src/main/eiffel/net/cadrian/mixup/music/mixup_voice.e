class MIXUP_VOICE

create {ANY}
   make

feature {ANY}
   anchor: MIXUP_NOTE_HEAD is
      do
         if music.is_empty then
            Result := reference
         else
            Result := music.first.anchor
         end
      end

   duration: INTEGER_64
   reference: MIXUP_NOTE_HEAD

   next_bar is
      do
         bars_.add_last(duration)
      end

   bars: TRAVERSABLE[INTEGER_64] is
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
         music.add_last(a_music)
         duration := duration + a_music.duration
         reference := a_music.anchor
      ensure
         music.last = a_music
      end

   add_chord (note_heads: COLLECTION[STRING]; note_length: INTEGER_64) is
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

   commit is
      do
         music.do_all(agent {MIXUP_MUSIC}.commit)
      end

   new_note_iterator: MIXUP_NOTES_ITERATOR is
      do
         create {MIXUP_NOTES_ITERATOR_ON_VOICE} Result.make(music)
      end

feature {MIXUP_VOICES}
   consolidate_bars (barset: SET[INTEGER_64]; duration_offset: like duration) is
      local
         d: like duration
         i: INTEGER
      do
         from
            i := bars_.lower
         until
            i > bars_.upper
         loop
            barset.add(bars_.item(i) + duration_offset)
            i := i + 1
         end
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
         create {FAST_ARRAY[INTEGER_64]} bars_.make(0)
         reference := a_reference
      ensure
         reference = a_reference
      end

   music: COLLECTION[MIXUP_MUSIC]
   bars_: COLLECTION[INTEGER_64]

invariant
   music /= Void

end
