expanded class MIXUP_EVENTS_ITERATOR_ITEM

feature {ANY}
   time: INTEGER_64
   xuplet_numerator  : INTEGER
   xuplet_denominator: INTEGER

   music: MIXUP_MUSIC
   instrument: FIXED_STRING

   with_lyrics: BOOLEAN

feature {ANY}
   fire_event (a_events: MIXUP_EVENTS) is
      do
         event.call([a_events, Current])
      end

   set_music (a_music: like music) is
      do
         music := a_music
      end

   set (a_event: like event; a_instrument: like instrument; a_time: like time; a_music: like music; a_lyrics: like with_lyrics) is
      do
         xuplet(a_event, a_instrument, a_time, a_music, 1, 1, a_lyrics)
      end

   xuplet (a_event: like event; a_instrument: like instrument; a_time: like time; a_music: like music;
           a_xuplet_numerator: like xuplet_numerator; a_xuplet_denominator: like xuplet_denominator; a_lyrics: like with_lyrics) is
      do
         event := a_event
         instrument := a_instrument
         time := a_time
         music := a_music
         xuplet_numerator := a_xuplet_numerator
         xuplet_denominator := a_xuplet_denominator
         with_lyrics := a_lyrics
      end

feature {}
   event: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM]]

end
