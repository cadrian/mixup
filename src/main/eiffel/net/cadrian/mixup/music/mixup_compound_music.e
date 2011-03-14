deferred class MIXUP_COMPOUND_MUSIC

inherit
   MIXUP_MUSIC

feature {ANY}
   valid_anchor: BOOLEAN is True

   add_music (a_music: MIXUP_MUSIC) is
      deferred
      end

   add_chord (note_heads: COLLECTION[FIXED_STRING]; note_length: INTEGER_64) is
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

   has_lyrics: BOOLEAN is True

end
