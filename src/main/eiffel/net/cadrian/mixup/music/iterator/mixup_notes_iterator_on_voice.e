class MIXUP_NOTES_ITERATOR_ON_VOICE
--
-- Iterator on a single voice
--

inherit
   MIXUP_NOTES_ITERATOR

create {MIXUP_VOICE}
   make

feature {ANY}
   start is
      do
         music_iterator := music.new_iterator
         time := start_time
         music_duration := 0
         set_note_iterator
      end

   is_off: BOOLEAN is
      do
         Result := music_iterator.is_off and then note_iterator.is_off
      end

   item: MIXUP_NOTES_ITERATOR_ITEM is
      do
         Result := note_iterator.item
      end

   next is
      do
         note_iterator.next
         if note_iterator.is_off then
            music_iterator.next
            if not music_iterator.is_off then
               set_note_iterator
            end
         end
      end

feature {MIXUP_VOICE}
   time: INTEGER_64
   music_iterator: ITERATOR[MIXUP_MUSIC]
   note_iterator: MIXUP_NOTES_ITERATOR
   music_duration: INTEGER_64

   set_note_iterator is
      do
         time := time + music_duration
         note_iterator := music_iterator.item.new_note_iterator(instrument, time)
         music_duration := music_iterator.item.duration
      ensure
         note_iterator /= Void
      end

feature {}
   make (a_instrument: like instrument; a_start_time: like start_time; a_music: like music) is
      require
         a_music /= Void
      do
         start_time := a_start_time
         instrument := a_instrument
         music := a_music
         start
      ensure
         instrument = a_instrument
         music = a_music
      end

   start_time: INTEGER_64
   instrument: FIXED_STRING
   music: ITERABLE[MIXUP_MUSIC]

invariant
   music /= Void
   music_iterator /= Void

end
