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
class MIXUP_TRANSFORM_NODE_NON_TERMINAL

inherit
   MIXUP_TRANSFORM_NODE

create {MIXUP_TRANSFORM_GRAMMAR}
   make

feature {ANY}
   count: INTEGER then nodes.count
      end

   node (index: INTEGER): MIXUP_TRANSFORM_NODE
      require
         index.in_range(1, count)
      do
         Result := nodes.item(nodes.count - index)
      ensure
         Result /= Void
         Result.is_valid
      end

   start_position: INTEGER then nodes.first.start_position
      end

   end_position: INTEGER then nodes.last.end_position
      end

   is_valid: BOOLEAN then not can_add
      end

   type: MIXUP_TRANSFORM_NODE_TYPE

   set_type (a_type: like type)
      do
         type := a_type
      end

feature {MIXUP_TRANSFORM_GRAMMAR}
   add_first (a_node: MIXUP_TRANSFORM_NODE)
      require
         a_node /= Void
         a_node.is_valid
         can_add
      do
         nodes.add_last(a_node)
         a_node.set_parent(Current)
      ensure
         nodes.last = a_node
         nodes.capacity = old nodes.capacity
         count = old count + 1
      end

   can_add: BOOLEAN then nodes.count < nodes.capacity
      end

feature {ANY}
   accept (visitor: VISITOR)
      local
         v: MIXUP_TRANSFORM_NODE_VISITOR
      do
         v ::= visitor
         v.visit_non_terminal(Current)
      end

feature {}
   make (a_name: like name; a_capacity: INTEGER)
      require
         a_name /= Void
         a_capacity >= 0
      do
         name := a_name
         create nodes.with_capacity(a_capacity)
      ensure
         name = a_name
         nodes /= Void
         nodes.capacity = a_capacity
         nodes.is_empty
      end

   nodes: FAST_ARRAY[MIXUP_TRANSFORM_NODE]
         -- BEWARE! nodes are kept in reverse order

invariant
   nodes /= Void
   nodes.capacity >= 0

end -- class MIXUP_TRANSFORM_NODE_NON_TERMINAL
