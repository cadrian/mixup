class MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   set

feature {ANY}
   time: INTEGER_64
   dynamic: MIXUP_DYNAMICS
   instrument: FIXED_STRING

   has_lyrics: BOOLEAN is False

feature {ANY}
   fire_event (a_player: MIXUP_PLAYER) is
      do
         event.call([a_player, Current])
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

   event: PROCEDURE[TUPLE[MIXUP_PLAYER, MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS]]

end
