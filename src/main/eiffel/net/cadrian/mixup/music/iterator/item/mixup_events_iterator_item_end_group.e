class MIXUP_EVENTS_ITERATOR_ITEM_END_GROUP

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument: FIXED_STRING

   has_lyrics: BOOLEAN is False

   fire_event (a_player: MIXUP_PLAYER) is
      do
         event.call([a_player, instrument])
      end

feature {}
   make (a_event: like event; a_time: like time; a_instrument: like instrument) is
      do
         event := a_event
         time := a_time
         instrument := a_instrument
      end

   event: PROCEDURE[TUPLE[MIXUP_PLAYER, FIXED_STRING]]

end
