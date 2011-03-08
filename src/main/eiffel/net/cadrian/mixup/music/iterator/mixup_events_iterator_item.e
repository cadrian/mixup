deferred class MIXUP_EVENTS_ITERATOR_ITEM

inherit
   COMPARABLE

feature {ANY}
   time: INTEGER_64 is
      deferred
      ensure
         Result >= 0
      end

   before_bar: BOOLEAN is
      deferred
      end

   has_lyrics: BOOLEAN is
      deferred
      end

   with_lyrics (a_lyrics: COLLECTION[FIXED_STRING]): MIXUP_EVENTS_ITERATOR_ITEM is
      require
         has_lyrics
      do
      ensure
         Result /= Void
      end

   fire_event (a_events: MIXUP_EVENTS) is
      deferred
      end

   infix "<" (other: MIXUP_EVENTS_ITERATOR_ITEM): BOOLEAN is
      do
         if time = other.time then
            Result := before_bar
         else
            Result := time < other.time
         end
      end

end
