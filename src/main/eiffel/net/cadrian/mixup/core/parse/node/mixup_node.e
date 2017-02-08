-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
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

   name: FIXED_STRING
         -- the name of the node in the grammar
      deferred
      ensure
         Result /= Void
      end

   source_line: INTEGER
      deferred
      end

   source_column: INTEGER
      deferred
      end

   source_index: INTEGER
      deferred
      end

feature {MIXUP_GRAMMAR}
   set_forgotten (a_forgotten: like forgotten)
      do
         forgotten := a_forgotten
      ensure
         forgotten = a_forgotten
      end

feature {MIXUP_NODE_HANDLER} -- Basic operations
   display (output: OUTPUT_STREAM; indent: INTEGER; p: STRING)
         -- Display the node in a tree fashion in the provided `output' stream
      deferred
      end

   generate (o: OUTPUT_STREAM)
         -- Generate the node exactly as it was written, including blanks and `forgotten' nodes, onto the
         -- provided `output' stream
      deferred
      end

feature {}
   generate_forgotten (o: OUTPUT_STREAM)
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
   set_parent (a_parent: like parent)
      require
         a_parent /= Void
         parent = Void
      do
         parent := a_parent
      ensure
         parent = a_parent
      end

feature {}
   do_indent (output: OUTPUT_STREAM; indent: INTEGER; p: STRING)
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
