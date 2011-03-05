deferred class MIXUP_NOTE

inherit
   MIXUP_MUSIC

feature {ANY}
   commit is
      do
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_NOTES_ITERATOR_ON_SINGLE_NOTE} Result.make(a_context, Current)
      end

   has_lyrics: BOOLEAN is True
      -- TODO: not always! (think slurs and ties)

feature {MIXUP_VOICE}
   frozen consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

end
