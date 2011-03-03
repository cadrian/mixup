deferred class MIXUP_NOTES_ITERATOR

inherit
   ITERATOR[MIXUP_NOTES_ITERATOR_ITEM]
      undefine
         is_equal
      end
   COMPARABLE

feature {ANY}
   infix "<" (other: MIXUP_NOTES_ITERATOR): BOOLEAN is
      do
         if is_off then
            Result := not other.is_off
         elseif other.is_off then
            Result := False
         else
            Result := item.time < other.item.time
         end
      end

feature {}
   iterable_generation: INTEGER is 0

end
