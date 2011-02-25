deferred class MIXUP_LIST_NODE

inherit
   MIXUP_NODE

insert
   TRAVERSABLE[MIXUP_NODE]

feature {ANY}
   frozen new_iterator: ITERATOR[MIXUP_NODE] is
      do
         check
            dont_use_this: False
         end
      end

   source_line: INTEGER is
      do
         if count > 0 then
            Result := first.source_line
         end
      end

   source_column: INTEGER is
      do
         if count > 0 then
            Result := first.source_column
         end
      end

   source_index: INTEGER is
      do
         if count > 0 then
            Result := first.source_index
         end
      end

feature {MIXUP_GRAMMAR}
   add (a_child: like item) is
      deferred
      ensure
         count = old count + 1
         first = a_child -- because the grammer is right-recursive the last child is added first
      end

end -- class MIXUP_LIST_NODE
