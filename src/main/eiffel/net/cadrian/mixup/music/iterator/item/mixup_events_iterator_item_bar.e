class MIXUP_EVENTS_ITERATOR_ITEM_BAR

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   set

feature {ANY}
   time: INTEGER_64
   bar: MIXUP_BAR
   instrument: FIXED_STRING

   style: FIXED_STRING is
      do
         Result := bar.style
      end

   has_lyrics: BOOLEAN is False

feature {ANY}
   fire_event (a_player: MIXUP_PLAYER) is
      do
         event.call([a_player, Current])
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

   event: PROCEDURE[TUPLE[MIXUP_PLAYER, MIXUP_EVENTS_ITERATOR_ITEM_BAR]]

end
