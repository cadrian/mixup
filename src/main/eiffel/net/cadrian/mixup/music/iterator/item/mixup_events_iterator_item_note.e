class MIXUP_EVENTS_ITERATOR_ITEM_NOTE

inherit
   MIXUP_EVENTS_ITERATOR_ITEM
      redefine
         with_lyrics
      end

create {ANY}
   set

feature {ANY}
   time: INTEGER_64
   note: MIXUP_NOTE
   instrument: FIXED_STRING

   has_lyrics: BOOLEAN

   with_lyrics (a_lyrics: COLLECTION[FIXED_STRING]): MIXUP_EVENTS_ITERATOR_ITEM is
      local
         lyrics: MIXUP_LYRICS; i: INTEGER
      do
         create lyrics.make(a_lyrics.count, note)
         from
            i := 0
         until
            i = a_lyrics.count
         loop
            lyrics.put(i, a_lyrics.item(i))
            i := i + 1
         end
         note := lyrics
         has_lyrics := False

         Result := Current
      end

feature {ANY}
   fire_event (a_player: MIXUP_PLAYER) is
      do
         event.call([a_player, Current])
      end

   set_note (a_note: like note) is
      do
         note := a_note
      end

feature {}
   set (a_event: like event; a_instrument: like instrument; a_time: like time; a_note: like note; a_lyrics: like has_lyrics) is
      do
         event := a_event
         instrument := a_instrument
         time := a_time
         note := a_note
         has_lyrics := a_lyrics
      end

   event: PROCEDURE[TUPLE[MIXUP_PLAYER, MIXUP_EVENTS_ITERATOR_ITEM_NOTE]]

end
