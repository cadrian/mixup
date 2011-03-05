class MIXUP_NOTES_ITERATOR_ON_VOICE
--
-- Iterator on a single voice
--

inherit
   MIXUP_EVENTS_ITERATOR

create {MIXUP_VOICE}
   make

feature {ANY}
   start is
      do
         music_iterator := music.new_iterator
         iter_context := context
         music_duration := 0
         set_events_iterator
      end

   is_off: BOOLEAN is
      do
         Result := music_iterator.is_off and then events_iterator.is_off
      end

   item: MIXUP_EVENTS_ITERATOR_ITEM is
      do
         Result := events_iterator.item
      end

   next is
      do
         events_iterator.next
         if events_iterator.is_off then
            music_iterator.next
            if not music_iterator.is_off then
               set_events_iterator
            end
         end
      end

feature {MIXUP_VOICE}
   music_iterator: ITERATOR[MIXUP_MUSIC]
   events_iterator: MIXUP_EVENTS_ITERATOR
   music_duration: INTEGER_64

   set_events_iterator is
      do
         iter_context.add_time(music_duration)
         events_iterator := music_iterator.item.new_events_iterator(iter_context)
         music_duration := music_iterator.item.duration
      ensure
         events_iterator /= Void
      end

feature {}
   make (a_context: like context; a_music: like music) is
      require
         a_music /= Void
      do
         context := a_context
         music := a_music
         start
      ensure
         music = a_music
      end

   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   iter_context: MIXUP_EVENTS_ITERATOR_CONTEXT
   music: ITERABLE[MIXUP_MUSIC]

invariant
   music /= Void
   music_iterator /= Void

end
