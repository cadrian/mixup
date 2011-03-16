class MIXUP_NOTES_ITERATOR_ON_GROUP
--
-- Decorated iterator with start and end events
--

inherit
   MIXUP_EVENTS_ITERATOR

create {MIXUP_VOICE}
   make

feature {ANY}
   start is
      do
         start_event := start_event_
         end_event := end_event_
         events_iterator.start
      end

   is_off: BOOLEAN is
      do
         Result := start_event = Void and then events_iterator.is_off and then end_event = Void
      end

   item: MIXUP_EVENTS_ITERATOR_ITEM is
      do
         if start_event /= Void then
            create {MIXUP_EVENTS_ITERATOR_ITEM_START_GROUP} Result.make(start_event, context.start_time, context.instrument.name,
                                                                        context.xuplet_numerator, context.xuplet_denominator, context.xuplet_text)
         elseif not events_iterator.is_off then
            Result := events_iterator.item
         elseif end_event /= Void then
            create {MIXUP_EVENTS_ITERATOR_ITEM_END_GROUP} Result.make(end_event, context.start_time + duration, context.instrument.name)
         end
      end

   next is
      do
         if start_event /= Void then
            start_event := Void
         elseif not events_iterator.is_off then
            events_iterator.next
         elseif end_event /= Void then
            end_event := Void
         end
      end

feature {MIXUP_VOICE}
   events_iterator: MIXUP_EVENTS_ITERATOR
   start_event: like start_event_
   end_event: like end_event_

feature {}
   make (a_context: like context; a_duration: like duration; a_start_event: like start_event; a_end_event: like end_event; a_events_iterator: like events_iterator) is
      require
         a_events_iterator /= Void
      do
         context := a_context
         duration := a_duration
         start_event_ := a_start_event
         end_event_ := a_end_event
         events_iterator := a_events_iterator
         start
      ensure
         start_event = a_start_event
         end_event = a_end_event
         events_iterator = a_events_iterator
      end

   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   duration: INTEGER_64
   start_event_: PROCEDURE[TUPLE[MIXUP_PLAYER, FIXED_STRING, INTEGER_64, INTEGER_64, FIXED_STRING]]
   end_event_: PROCEDURE[TUPLE[MIXUP_PLAYER, FIXED_STRING]]

invariant
   events_iterator /= Void

end
