class MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   set

feature {ANY}
   time: INTEGER_64
   music: MIXUP_DYNAMICS
   instrument: FIXED_STRING

   has_lyrics: BOOLEAN is False

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
   set (a_event: like event; a_instrument: like instrument; a_time: like time; a_music: like music) is
      do
         event := a_event
         instrument := a_instrument
         time := a_time
         music := a_music
      end

   event: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS]]

end
