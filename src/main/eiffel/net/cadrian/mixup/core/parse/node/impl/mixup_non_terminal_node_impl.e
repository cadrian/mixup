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
class MIXUP_NON_TERMINAL_NODE_IMPL

inherit
   MIXUP_NON_TERMINAL_NODE

create {MIXUP_NODE_FACTORY}
   make

feature {ANY}
   name: FIXED_STRING

   accept (visitor: VISITOR)
      local
         v: MIXUP_NON_TERMINAL_NODE_IMPL_VISITOR
      do
         v ::= visitor
         v.visit_mixup_non_terminal_node_impl(Current)
      end

   name_at (index: INTEGER): FIXED_STRING
      do
         Result := names.item(index - lower + names.lower)
      end

   node_at (index: INTEGER): MIXUP_NODE
      do
         Result := nodes.item(index)
      end

   valid_index (index: INTEGER): BOOLEAN
      do
         Result := nodes.valid_index(index)
      end

   lower: INTEGER
      do
         Result := nodes.lower
      end

   upper: INTEGER
      do
         Result := nodes.upper
      end

   count: INTEGER
      do
         Result := nodes.count
      end

   is_empty: BOOLEAN
      do
         Result := nodes.is_empty
      end

   accept_all (visitor: VISITOR)
      do
         nodes.do_all(agent {VISITABLE}.accept(visitor))
      end

feature {MIXUP_GRAMMAR}
   set (index: INTEGER; node: MIXUP_NODE)
      do
         nodes.put(node, index)
         node.set_parent(Current)
      end

feature {MIXUP_NODE_HANDLER}
   display (output: OUTPUT_STREAM; indent: INTEGER; p: STRING)
      local
         i: INTEGER
      do
         do_indent(output, indent, p)
         output.put_character('"')
         output.put_string(name)
         output.put_line(once "%":")
         from
            i := lower
         until
            i > upper
         loop
            node_at(i).display(output, indent + 1, " * ")
            i := i + 1
         end
      end

   generate (o: OUTPUT_STREAM)
      local
         i: INTEGER
      do
         from
            i := lower
         until
            i > upper
         loop
            node_at(i).generate(o)
            i := i + 1
         end
         generate_forgotten(o)
      end

feature {}
   make (a_name: like name; a_names: like names)
      do
         name := a_name
         names := a_names
         create nodes.make(a_names.count)
      ensure
         name = a_name
         names = a_names
      end

   names: TRAVERSABLE[FIXED_STRING]

   nodes: FAST_ARRAY[MIXUP_NODE]

invariant
   names.count = nodes.count

end -- class MIXUP_NON_TERMINAL_NODE_IMPL
