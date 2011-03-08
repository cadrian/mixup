class MIXUP_NOTES_ITERATOR_ON_SINGLE_NOTE
--
-- Trivial iterator.
--

inherit
   MIXUP_EVENTS_ITERATOR

create {MIXUP_NOTE}
   make

feature {ANY}
   start is
      do
      end

   is_off: BOOLEAN

   item: MIXUP_EVENTS_ITERATOR_ITEM_NOTE

   next is
      do
         is_off := True
      end

feature {}
   make (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT; a_note: MIXUP_NOTE) is
      require
         a_note /= Void
      do
         create {MIXUP_EVENTS_ITERATOR_ITEM_NOTE} item.set(event_set_note, a_context.instrument.name, a_context.start_time, a_note, True)
      ensure
         item.time = a_context.start_time
         not is_off
      end

   event_set_note: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM_NOTE]] is
      once
         Result := agent set_note
      end

   set_note (a_events: MIXUP_EVENTS; a_item: MIXUP_EVENTS_ITERATOR_ITEM_NOTE) is
      require
         a_events /= Void
      do
         a_events.fire_set_note(a_item.instrument, a_item.note)
      end

invariant
   item.note /= Void

end
