class MIXUP_EVENTS_ITERATOR_ITEM_BAR

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   set

feature {ANY}
   time: INTEGER_64
   bar: MIXUP_BAR
   instrument: FIXED_STRING

   has_lyrics: BOOLEAN is False

feature {ANY}
   fire_event (a_events: MIXUP_EVENTS) is
      do
         event.call([a_events, Current])
      end

   set_bar (a_bar: like bar) is
      do
         bar := a_bar
      end

feature {}
   set (a_event: like event; a_instrument: like instrument; a_time: like time; a_bar: like bar) is
      do
         event := a_event
         instrument := a_instrument
         time := a_time
         bar := a_bar
      end

   event: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM_BAR]]

end