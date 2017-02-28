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

   start_position: INTEGER
      local
         i: INTEGER
      do
         from
            i := nodes.upper
         until
            Result > 0 or else i < nodes.lower
         loop
            if nodes.item(i).has_position then
               Result := nodes.item(i).start_position
            end
            i := i - 1
         end
      end

   end_position: INTEGER
      local
         i: INTEGER
      do
         from
            i := nodes.lower
         until
            Result > 0 or else i > nodes.upper
         loop
            if nodes.item(i).has_position then
               Result := nodes.item(i).end_position
            end
            i := i + 1
         end
      end

   has_position: BOOLEAN
      local
         i: INTEGER
      do
         from
            i := nodes.upper
         until
            Result or else i < nodes.lower
         loop
            Result := nodes.item(i).has_position
            i := i - 1
         end
      end

   is_valid: BOOLEAN True

   type: MIXUP_TRANSFORM_TYPE

   set_type (a_type: like type)
      do
         type := a_type
      end

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
