deferred class MIXUP_EVENTS_CACHED_ITERATOR

inherit
   MIXUP_EVENTS_ITERATOR

feature {ANY}
   item: like item_memory is
      do
         Result := item_memory
         if Result = Void then
            Result := fetch_item
            item_memory := Result
         end
      end

   next is
      do
         go_next
         item_memory := Void
      end

feature {}
   item_memory: MIXUP_EVENT

   fetch_item: like item_memory is
      require
         item_memory = Void
         not is_off
      deferred
      ensure
         Result /= Void
      end

   go_next is
      require
         fetched: item_memory /= Void
      deferred
      end

end
