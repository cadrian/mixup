class MIXUP_EVENTS_ITERATOR_ITEM_START_GROUP

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument: FIXED_STRING
   numerator: INTEGER_64
   denominator: INTEGER_64
   text: FIXED_STRING

   before_bar: BOOLEAN is False

   has_lyrics: BOOLEAN is False

   fire_event (a_events: MIXUP_EVENTS) is
      do
         event.call([a_events, instrument, numerator, denominator, text])
      end

feature {}
   make (a_event: like event; a_time: like time; a_instrument: like instrument; a_numerator: like numerator; a_denominator: like denominator; a_text: like text) is
      do
         event := a_event
         time := a_time
         instrument := a_instrument
         numerator := a_numerator
         denominator := a_denominator
         text := a_text
      end

   event: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, INTEGER_64, INTEGER_64, FIXED_STRING]]

end
