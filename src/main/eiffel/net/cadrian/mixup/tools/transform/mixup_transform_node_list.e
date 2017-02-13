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
class MIXUP_TRANSFORM_NODE_LIST

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

   start_position: INTEGER then if nodes.is_empty then 0 else nodes.first.start_position end
      end

   end_position: INTEGER then nodes.last.end_position
      end

   is_valid: BOOLEAN True

feature {MIXUP_TRANSFORM_GRAMMAR}
   add_first (a_node: MIXUP_TRANSFORM_NODE)
      require
         a_node /= Void
         a_node.is_valid
      do
         nodes.add_last(a_node)
         a_node.set_parent(Current)
      ensure
         nodes.last = a_node
         count = old count + 1
      end

feature {ANY}
   accept (visitor: VISITOR)
      local
         v: MIXUP_TRANSFORM_NODE_VISITOR
      do
         v ::= visitor
         v.visit_list(Current)
      end

feature {}
   make (a_name: like name)
      require
         a_name /= Void
      do
         name := a_name
         create nodes.with_capacity(4)
      ensure
         name = a_name
         nodes /= Void
         nodes.is_empty
      end

   nodes: FAST_ARRAY[MIXUP_TRANSFORM_NODE]
         -- BEWARE! nodes are kept in reverse order

invariant
   nodes /= Void

end -- class MIXUP_TRANSFORM_NODE_LIST
