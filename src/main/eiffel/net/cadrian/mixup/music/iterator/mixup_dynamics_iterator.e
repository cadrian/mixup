class MIXUP_DYNAMICS_ITERATOR
--
-- Trivial iterator.
--

inherit
   MIXUP_EVENTS_ITERATOR

create {MIXUP_DYNAMICS}
   make

feature {ANY}
   start is
      do
      end

   is_off: BOOLEAN

   item: MIXUP_EVENTS_ITERATOR_ITEM

   next is
      do
         is_off := True
      end

feature {}
   make (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT; a_dynamics: MIXUP_DYNAMICS) is
      require
         a_dynamics /= Void
      do
         create {MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS} item.set(event_set_dynamics, a_context.instrument.name, a_context.start_time, a_dynamics)
      ensure
         item.time = a_context.start_time
         not is_off
      end

   event_set_dynamics: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS]] is
      once
         Result := agent set_dynamics
      end

   set_dynamics (a_events: MIXUP_EVENTS; a_item: MIXUP_EVENTS_ITERATOR_ITEM_DYNAMICS) is
      require
         a_events /= Void
      do
         a_events.fire_set_dynamics(a_item.instrument, a_item.time, a_item.music.text, a_item.music.position)
      end

invariant
   item.music /= Void

end
