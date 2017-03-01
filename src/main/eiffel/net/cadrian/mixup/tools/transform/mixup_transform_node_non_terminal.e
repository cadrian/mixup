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

insert
   LOGGING

create {MIXUP_TRANSFORM_GRAMMAR}
   make, make_empty

feature {ANY}
   count: INTEGER
      do
         if nodes /= Void then
            Result := nodes.count
         end
      end

   node (index: INTEGER): MIXUP_TRANSFORM_NODE
      require
         index.in_range(1, count)
      do
         Result := nodes.item(nodes.count - index)
      ensure
         Result /= Void
      end

   start_position: INTEGER
      local
         i: INTEGER
      do
         if nodes /= Void then
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
      end

   end_position: INTEGER
      local
         i: INTEGER
      do
         if nodes /= Void then
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
      end

   has_position: BOOLEAN
      local
         i: INTEGER
      do
         if nodes /= Void then
            from
               i := nodes.upper
            until
               Result or else i < nodes.lower
            loop
               Result := nodes.item(i).has_position
               i := i - 1
            end
         end
      end

   is_valid: BOOLEAN then nodes = Void or else nodes.count = nodes.capacity
      end

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
         can_add
      do
         nodes.add_last(a_node)
         a_node.set_parent(Current)
      ensure
         nodes.last = a_node
         nodes.capacity = old nodes.capacity
         count = old count + 1
      end

   can_add: BOOLEAN then nodes /= Void and then nodes.count < nodes.capacity
      end

feature {ANY}
   accept (visitor: VISITOR)
      local
         v: MIXUP_TRANSFORM_NODE_VISITOR
      do
         v ::= visitor
         log.trace.put_line(">>NT:" + name)
         v.visit_non_terminal(Current)
         log.trace.put_line("<<NT:" + name)
      end

feature {}
   make_empty (a_name: like name)
      require
         a_name /= Void
      do
         name := a_name
      ensure
         name = a_name
         nodes = Void
         not has_position
      end

   make (a_name: like name; a_capacity: INTEGER)
      require
         a_name /= Void
         a_capacity > 0
      do
         name := a_name
         create nodes.with_capacity(a_capacity)
      ensure
         name = a_name
         nodes /= Void
         nodes.capacity = a_capacity
         nodes.is_empty
         can_add
      end

   nodes: FAST_ARRAY[MIXUP_TRANSFORM_NODE]
         -- BEWARE! nodes are kept in reverse order

invariant
   nodes /= Void implies nodes.capacity > 0
   nodes = Void implies not has_position
   can_add xor is_valid

end -- class MIXUP_TRANSFORM_NODE_NON_TERMINAL
