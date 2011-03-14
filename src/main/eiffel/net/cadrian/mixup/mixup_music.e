deferred class MIXUP_MUSIC

feature {ANY}
   duration: INTEGER_64 is
      deferred
      end

   valid_anchor: BOOLEAN is
      deferred
      end

   anchor: MIXUP_NOTE_HEAD is
      require
         valid_anchor
      deferred
      end

   commit (a_context: MIXUP_CONTEXT) is
      deferred
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      deferred
      end

   has_lyrics: BOOLEAN is
      deferred
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      require
         bars /= Void
      deferred
      end

end
