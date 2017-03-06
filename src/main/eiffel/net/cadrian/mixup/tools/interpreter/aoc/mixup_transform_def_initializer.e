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
class MIXUP_TRANSFORM_DEF_INITIALIZER

inherit
   MIXUP_TRANSFORM_NODE_VISITOR

insert
   MIXUP_TRANSFORM_GRAMMAR_CONSTANTS

create {MIXUP_TRANSFORM_DEF}
   make

feature {MIXUP_TRANSFORM_DEF}
   name: STRING
   arguments: COLLECTION[STRING]
   is_function: BOOLEAN
   body: MIXUP_TRANSFORM_NODE

feature {MIXUP_TRANSFORM_NODE_TERMINAL}
   visit_terminal (a_node: MIXUP_TRANSFORM_NODE_TERMINAL)
      do
         if a_node.name = kw_identifier then
            last_identifier := a_node.image.image
         end
      end

feature {MIXUP_TRANSFORM_NODE_NON_TERMINAL}
   visit_non_terminal (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         i, ac: INTEGER; has_ac: BOOLEAN
      do
         if a_node.name = nt_aoccont and then a_node.node(1).name = kw_assign then
            check
               addressable_count > 0
               last_identifier /= Void
            end
            if addressable_count = 1 and then last_identifier.is_equal("result") then
               is_function := True
            end
         elseif a_node.name = nt_addressable then
            addressable_count := addressable_count + 1
         elseif a_node.name = nt_assignorcall or else a_node.name = nt_expatom then
            has_ac := True
            ac := addressable_count
            addressable_count := 0
         end

         from
            i := 1
         until
            i > a_node.count
         loop
            a_node.node(i).accept(Current)
            i := i + 1
         end

         if has_ac then
            addressable_count := ac
         elseif a_node.name = nt_argument then
            check
               arguments /= Void
            end
            arguments.add_first(last_identifier)
         end
      end

feature {MIXUP_TRANSFORM_NODE_LIST}
   visit_list (a_node: MIXUP_TRANSFORM_NODE_LIST)
      local
         i: INTEGER
      do
         if a_node.name = nt_list_argument then
            create {RING_ARRAY[STRING]} arguments.with_capacity(a_node.count, a_node.count)
         end

         from
            i := 1
         until
            i > a_node.count
         loop
            a_node.node(i).accept(Current)
            i := i + 1
         end
      end

feature {}
   make (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         a_node /= Void
         a_node.name = nt_def
      do
         a_node.node(2).accept(Current)
         name := last_identifier
         a_node.node(4).accept(Current)
         body := a_node.node(6)
         body.accept(Current)
      end

   last_identifier: STRING
   addressable_count: INTEGER

end -- class MIXUP_TRANSFORM_DEF_INITIALIZER
