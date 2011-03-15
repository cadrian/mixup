class MIXUP_EVENTS_ITERATOR_ITEM_DECORATED

inherit
   MIXUP_EVENTS_ITERATOR_ITEM

create {ANY}
   make

feature {ANY}
   time: INTEGER_64 is
      do
         Result := context.start_time
      end

   has_lyrics: BOOLEAN is False

   fire_event (a_events: MIXUP_EVENTS) is
      do
         event.call([a_events, context])
      end

feature {}
   make (a_event: like event; a_context: like context) is
      do
         event := a_event
         context := a_context
      end

   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   event: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_CONTEXT]]

end
