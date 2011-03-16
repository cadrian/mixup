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
         a_player.play(event_factory.item([instrument]))
      end

feature {}
   make (a_event_factory: like event_factory; a_time: like time; a_instrument: like instrument) is
      do
         event_factory := a_event_factory
         time := a_time
         instrument := a_instrument
      end

   event_factory: FUNCTION[TUPLE[FIXED_STRING], MIXUP_EVENT]

end
