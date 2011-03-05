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
         item.set(event_set_dynamics, a_context.instrument.name, a_context.start_time, a_dynamics, True)
      ensure
         item.time = a_context.start_time
         item.music = a_dynamics
         not is_off
      end

   event_set_dynamics: PROCEDURE[TUPLE[MIXUP_EVENTS, MIXUP_EVENTS_ITERATOR_ITEM]] is
      once
         Result := agent set_dynamics
      end

   set_dynamics (a_events: MIXUP_EVENTS; a_item: MIXUP_EVENTS_ITERATOR_ITEM) is
      require
         a_events /= Void
      local
         dynamics: MIXUP_DYNAMICS
      do
         dynamics ::= a_item.music
         a_events.fire_set_dynamics(a_item.instrument, a_item.time, dynamics.text, dynamics.position)
      end

invariant
   item.note /= Void

end
