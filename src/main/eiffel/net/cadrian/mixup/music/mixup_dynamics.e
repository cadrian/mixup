class MIXUP_DYNAMICS

inherit
   MIXUP_MUSIC

create {ANY}
   make

feature {ANY}
   duration: INTEGER_64 is 0
   anchor: MIXUP_NOTE_HEAD
   text: FIXED_STRING
   position: FIXED_STRING

   commit is
      do
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_DYNAMICS_ITERATOR} Result.make(a_context, Current)
      end

   has_lyrics: BOOLEAN is False

feature {MIXUP_VOICE}
   frozen consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

feature {}
   make (a_anchor: like anchor; a_text, a_position: FIXED_STRING) is
      require
         a_text /= Void
      do
         anchor := a_anchor
         text := a_text
         position := a_position
      ensure
         anchor = a_anchor
         text = a_text
         position = a_position
      end

invariant
   text /= Void

end
