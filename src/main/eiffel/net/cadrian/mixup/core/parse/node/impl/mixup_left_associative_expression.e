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
expanded class MIXUP_LEFT_ASSOCIATIVE_EXPRESSION

feature {MIXUP_GRAMMAR}
   expression_name: FIXED_STRING
   right_node: MIXUP_NODE
   operator_nodes: COLLECTION[MIXUP_NODE]

   set (a_expression_name: like expression_name; a_operator_names: like operator_names;
        a_right_node: like right_node; a_operator_nodes: like operator_nodes)
      require
         a_operator_names.for_all(agent (o: ABSTRACT_STRING): BOOLEAN is do Result := o /= Void end)
      do
         expression_name := a_expression_name
         operator_names := a_operator_names
         right_node := a_right_node
         operator_nodes := a_operator_nodes
      ensure
         expression_name = a_expression_name
         operator_names = a_operator_names
         right_node = a_right_node
         operator_nodes = a_operator_nodes
      end

   append_operators_in (operators: COLLECTION[FIXED_STRING])
      require
         operators /= Void
      local
         i: INTEGER
      do
         from
            i := operator_names.lower
         until
            i > operator_names.upper
         loop
            operators.add_last(operator_names.item(i).intern)
            i := i + 1
         end
      end

   operator_names_out: ABSTRACT_STRING
      do
         Result := &operator_names
      end

feature {}
   operator_names: COLLECTION[ABSTRACT_STRING]

end -- class MIXUP_LEFT_ASSOCIATIVE_EXPRESSION
