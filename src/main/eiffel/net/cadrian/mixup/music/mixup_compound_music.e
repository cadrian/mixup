deferred class MIXUP_COMPOUND_MUSIC

inherit
   MIXUP_MUSIC

feature {ANY}
   add_music (a_music: MIXUP_MUSIC) is
      deferred
      end

   add_chord (note_heads: COLLECTION[STRING]; note_length: INTEGER_64) is
      deferred
      end

   reference: MIXUP_NOTE_HEAD is
      deferred
      end

   next_bar is
      deferred
      end

   bars: TRAVERSABLE[INTEGER_64] is
      deferred
      end

   up_staff is
      deferred
      end

   down_staff is
      deferred
      end

   new_note_iterator: ITERATOR[TUPLE[INTEGER_64, MIXUP_NOTE]] is
      do
         create {MIXUP_NOTES_ITERATOR} Result.make(Current)
      end

end
