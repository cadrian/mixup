deferred class MIXUP_TERMINAL_NODE

inherit
   MIXUP_NODE

feature {ANY}
   image: MIXUP_IMAGE is
      deferred
      end

   source_line: INTEGER is
      do
         Result := image.line
      end

   source_column: INTEGER is
      do
         Result := image.column
      end

   source_index: INTEGER is
      do
         Result := image.index
      end

end -- class MIXUP_TERMINAL_NODE
