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
         notes := music.new_iterator
         set_note_iterator(notes.item.new_note_iterator(instrument))
      end

   is_off: BOOLEAN is
      do
         Result := notes.is_off and then note_iterator.is_off
      end

   item: MIXUP_NOTES_ITERATOR_ITEM is
      do
         Result := note_iterator.item
      end

   next is
      do
         time := time + note_iterator.item.time
         note_iterator.next
         if note_iterator.is_off then
            notes.next
            if not notes.is_off then
               set_note_iterator(notes.item.new_note_iterator(instrument))
            end
         end
      end

feature {MIXUP_VOICE}
   time: INTEGER_64
   notes: ITERATOR[MIXUP_MUSIC]
   note_iterator: MIXUP_NOTES_ITERATOR

   set_note_iterator (a_note_iterator: like note_iterator) is
      require
         a_note_iterator /= Void
      do
         note_iterator := a_note_iterator
      ensure
         note_iterator = a_note_iterator
      end

feature {}
   make (a_instrument: like instrument; a_music: like music) is
      require
         a_music /= Void
      do
         instrument := a_instrument
         music := a_music
         start
      ensure
         instrument = a_instrument
         music = a_music
      end

   instrument: FIXED_STRING
   music: ITERABLE[MIXUP_MUSIC]

invariant
   music /= Void
   notes /= Void

end
