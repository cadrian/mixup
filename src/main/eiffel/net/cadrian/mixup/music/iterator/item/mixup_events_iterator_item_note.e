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
   xuplet_numerator  : INTEGER_64
   xuplet_denominator: INTEGER_64

   music: MIXUP_NOTE
   instrument: FIXED_STRING

   has_lyrics: BOOLEAN

   with_lyrics (a_lyrics: COLLECTION[FIXED_STRING]): MIXUP_EVENTS_ITERATOR_ITEM is
      local
         lyrics: MIXUP_LYRICS; i: INTEGER
      do
         create lyrics.make(a_lyrics.count, music)
         from
            i := 0
         until
            i = a_lyrics.count
         loop
            lyrics.put(i, a_lyrics.item(i))
            i := i + 1
         end
         music := lyrics
         has_lyrics := False

         Result := Current
      end

feature {ANY}
   fire_event (a_events: MIXUP_EVENTS) is
      do
         event.call([a_events, Current])
      end

   set_music (a_music: like music) is
      do
         music := a_music
      end

feature {}
   set (a_event: like event; a_instrument: like instrument; a_time: like time; a_music: like music;
        a_xuplet_numerator: like xuplet_numerator; a_xuplet_denominator: like xuplet_denominator; a_lyrics: like has_lyrics) is
      do
         event := a_event
         instrument := a_instrument
         time := a_time
         music := a_music
         xuplet_numerator := a_xuplet_numerator
         xuplet_denominator := a_xuplet_denominator
         has_lyrics := a_lyrics
      end

   event: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM_NOTE]]

end
