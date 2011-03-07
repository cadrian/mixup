class MIXUP_EVENTS_ITERATOR_ITEM_START_GROUP

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument: FIXED_STRING
   text: FIXED_STRING

   has_lyrics: BOOLEAN is False

   fire_event (a_events: MIXUP_EVENTS) is
      do
         event.call([a_events, instrument, text])
      end

feature {}
   make (a_event: like event; a_time: like time; a_instrument: like instrument; a_text: like text) is
      do
         event := a_event
         time := a_time
         instrument := a_instrument
         text := a_text
      end

   event: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, FIXED_STRING]]

end
