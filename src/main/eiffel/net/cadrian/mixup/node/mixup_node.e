deferred class MIXUP_NODE
   --
   -- Provides two basic operations: `display' for debug purposes, and `generate' for more generic node
   -- handling.
   --
   -- Any other operation should be provided by an external VISITOR.
   --
   -- See also: MIXUP_NON_TERMINAL_NODE, MIXUP_LIST_NODE, MIXUP_TERMINAL_NODE, MIXUP_IMAGE
   --

inherit
   VISITABLE

insert
   MIXUP_NODE_HANDLER

feature {ANY}
   parent: MIXUP_NODE
         -- the parent node

   forgotten: FAST_ARRAY[MIXUP_NODE]
         -- used when this node is in a MIXUP_LIST_NODE and nodes are between this node and the next one

   name: FIXED_STRING is
         -- the name of the node in the grammar
      deferred
      ensure
         name /= Void
      end

   source_line: INTEGER is
      deferred
      end

   source_column: INTEGER is
      deferred
      end

   source_index: INTEGER is
      deferred
      end

feature {MIXUP_GRAMMAR}
   set_forgotten (a_forgotten: like forgotten) is
      do
         forgotten := a_forgotten
      ensure
         forgotten = a_forgotten
      end

feature {MIXUP_NODE_HANDLER} -- Basic operations
   display (output: OUTPUT_STREAM; indent: INTEGER; p: STRING) is
         -- Display the node in a tree fashion in the provided `output' stream
      deferred
      end

   generate (o: OUTPUT_STREAM) is
         -- Generate the node exactly as it was written, including blanks and `forgotten' nodes, onto the
         -- provided `output' stream
      deferred
      end

feature {}
   generate_forgotten (o: OUTPUT_STREAM) is
      local
         i: INTEGER
      do
         if forgotten /= Void then
            from
               i := forgotten.lower
            until
               i > forgotten.upper
            loop
               forgotten.item(i).generate(o)
               i := i + 1
            end
         end
      end

feature {MIXUP_NON_TERMINAL_NODE, MIXUP_LIST_NODE}
   set_parent (a_parent: like parent) is
      require
         a_parent /= Void
         parent = Void
      do
         parent := a_parent
      ensure
         parent = a_parent
      end

feature {}
   do_indent (output: OUTPUT_STREAM; indent: INTEGER; p: STRING) is
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > indent
         loop
            output.put_string(once "   ")
            i := i + 1
         end
         if p /= Void then
            output.put_string(p)
         end
      end

end -- class MIXUP_NODE
