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
class MIXUP_TERMINAL_NODE_IMPL

inherit
   MIXUP_TERMINAL_NODE

create {MIXUP_NODE_FACTORY}
   make

feature {ANY}
   name: FIXED_STRING

   image: MIXUP_IMAGE

   accept (visitor: VISITOR)
      local
         v: MIXUP_TERMINAL_NODE_IMPL_VISITOR
      do
         v ::= visitor
         v.visit_mixup_terminal_node_impl(Current)
      end

feature {MIXUP_NODE_HANDLER}
   display (output: OUTPUT_STREAM; indent: INTEGER; p: STRING)
      do
         do_indent(output, indent, p)
         output.put_character('"')
         output.put_string(name)
         output.put_string(once "%": ")
         output.put_line(image.image)
      end

   generate (o: OUTPUT_STREAM)
      do
         o.put_string(image.blanks)
         o.put_string(image.image)
         generate_forgotten(o)
      end

feature {}
   make (a_name: like name; a_image: like image)
      do
         name := a_name
         image := a_image
      ensure
         name = a_name
         image = a_image
      end

end -- class MIXUP_TERMINAL_NODE_IMPL
