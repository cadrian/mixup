class MIXUP_BAR_ITERATOR
--
-- Trivial iterator.
--

inherit
   MIXUP_EVENTS_ITERATOR

create {MIXUP_BAR}
   make

feature {ANY}
   start is
      do
      end

   is_off: BOOLEAN

   item: MIXUP_EVENTS_ITERATOR_ITEM_BAR

   next is
      do
         is_off := True
      end

feature {}
   make (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT; a_bar: MIXUP_BAR) is
      require
         a_bar /= Void
      do
         create {MIXUP_EVENTS_ITERATOR_ITEM_BAR} item.set(event_set_bar, a_context.instrument.name, a_context.start_time, a_bar)
      ensure
         item.time = a_context.start_time
         not is_off
      end

   event_set_bar: PROCEDURE[TUPLE[MIXUP_PLAYER, MIXUP_EVENTS_ITERATOR_ITEM_BAR]] is
      once
         Result := agent set_bar
      end

   set_bar (a_player: MIXUP_PLAYER; a_item: MIXUP_EVENTS_ITERATOR_ITEM_BAR) is
      require
         a_player /= Void
      do
         a_player.next_bar(a_item.instrument, a_item.style)
      end

invariant
   item.dynamic /= Void

end
