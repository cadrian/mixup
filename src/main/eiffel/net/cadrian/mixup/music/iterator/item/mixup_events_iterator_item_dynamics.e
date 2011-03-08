class MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   set

feature {ANY}
   time: INTEGER_64
   dynamic: MIXUP_DYNAMICS
   instrument: FIXED_STRING

   before_bar: BOOLEAN is False

   has_lyrics: BOOLEAN is False

feature {ANY}
   fire_event (a_events: MIXUP_EVENTS) is
      do
         event.call([a_events, Current])
      end

   set_dynamic (a_dynamic: like dynamic) is
      do
         dynamic := a_dynamic
      end

feature {}
   set (a_event: like event; a_instrument: like instrument; a_time: like time; a_dynamic: like dynamic) is
      do
         event := a_event
         instrument := a_instrument
         time := a_time
         dynamic := a_dynamic
      end

   event: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS]]

end
