class MIXUP_LIST_NODE_IMPL

inherit
   MIXUP_LIST_NODE

insert
   TRAVERSABLE[MIXUP_NODE]

create {MIXUP_NODE_FACTORY}
   make

feature {ANY}
   name: FIXED_STRING

   accept (visitor: VISITOR) is
      local
         v: MIXUP_LIST_NODE_IMPL_VISITOR
      do
         v ::= visitor
         v.visit_mixup_list_node_impl(Current)
      end

   item (i: INTEGER): MIXUP_NODE is
      do
         Result := children.item(i)
      end

   lower: INTEGER is
      do
         Result := children.lower
      end

   upper: INTEGER is
      do
         Result := children.upper
      end

   count: INTEGER is
      do
         Result := children.count
      end

   first: MIXUP_NODE is
      do
         Result := children.first
      end

   last: MIXUP_NODE is
      do
         Result := children.last
      end

   is_empty: BOOLEAN is
      do
         Result := children.is_empty
      end

   accept_all (visitor: VISITOR) is
      do
         children.do_all(agent {VISITABLE}.accept(visitor))
      end

feature {MIXUP_GRAMMAR}
   add (a_child: like item) is
      do
         children.add_first(a_child)
         a_child.set_parent(Current)
      end

feature {MIXUP_NODE_HANDLER}
   display (output: OUTPUT_STREAM; indent: INTEGER; p: STRING) is
      local
         i: INTEGER; n: STRING
      do
         n := once ""
         do_indent(output, indent, p)
         output.put_character('"')
         output.put_string(name)
         output.put_string(once "%": ")
         output.put_integer(children.count)
         output.put_string(once " atom")
         if children.count /= 1 then
            output.put_character('s')
         end
         output.put_new_line
         from
            i := lower
         until
            i > upper
         loop
            n.copy(once "#")
            (i - lower + 1).append_in(n)
            n.append(once ": ")
            item(i).display(output, indent + 1, n)
            i := i + 1
         end
      end

   generate (o: OUTPUT_STREAM) is
      local
         i: INTEGER
      do
         from
            i := lower
         until
            i > upper
         loop
            item(i).generate(o)
            i := i + 1
         end
         generate_forgotten(o)
      end

feature {}
   make (a_name: like name) is
      do
         name := a_name
         create children.with_capacity(0, 0)
      ensure
         name = a_name
      end

   children: RING_ARRAY[MIXUP_NODE]

end -- class MIXUP_LIST_NODE_IMPL
