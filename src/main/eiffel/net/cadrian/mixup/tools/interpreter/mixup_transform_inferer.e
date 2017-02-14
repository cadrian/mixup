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
class MIXUP_TRANSFORM_INFERER
   --
   -- Type inference
   --

inherit
   MIXUP_TRANSFORM_NODE_VISITOR

insert
   LOGGING
   MIXUP_TRANSFORM_NODE_TYPES

create {MIXUP_TRANSFORM}
   make

feature {ANY}
   error: ABSTRACT_STRING

feature {MIXUP_TRANSFORM_NODE_TERMINAL}
   visit_terminal (a_node: MIXUP_TRANSFORM_NODE_TERMINAL)
      do
         type := a_node.image.type
      end

feature {MIXUP_TRANSFORM_NODE_NON_TERMINAL}
   visit_non_terminal (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         inferers.fast_at(a_node.name).call([a_node])
         if type = Void then
            log.trace.put_line("Inferred NT: #(1) -- unknown type" # a_node.name)
         else
            log.trace.put_line("Inferred NT: #(1) -- type: #(2)" # a_node.name # type.name)
         end
      end

feature {MIXUP_TRANSFORM_NODE_LIST}
   visit_list (a_node: MIXUP_TRANSFORM_NODE_LIST)
      local
         i: INTEGER
      do
         from
            i := 1
         until
            i > a_node.count or else error /= Void
         loop
            a_node.node(i).accept(Current)
            i := i + 1
         end
      end

feature {}
   make (a_root: MIXUP_TRANSFORM_NODE)
      require
         a_root /= Void
      do
         create_inferers
         a_root.accept(Current)
      end

   create_inferers
      do
         create inferers
         inferers.put(agent infer_transformation(?), "Transformation".intern)
         inferers.put(agent infer_input(?), "Input".intern)
         inferers.put(agent infer_output(?), "Output".intern)
         inferers.put(agent infer_transform(?), "Transform".intern)
         inferers.put(agent infer_instruction(?), "Instruction".intern)
         inferers.put(agent infer_assignorcall(?), "AssignOrCall".intern)
         inferers.put(agent infer_aoccont(?), "AOCCont".intern)
         inferers.put(agent infer_case(?), "Case".intern)
         inferers.put(agent infer_if(?), "If".intern)
         inferers.put(agent infer_skip(?), "Skip".intern)
         inferers.put(agent infer_when(?), "When".intern)
         inferers.put(agent infer_then(?), "Then".intern)
         inferers.put(agent infer_elseif(?), "ElseIf".intern)
         inferers.put(agent infer_else(?), "Else".intern)
         inferers.put(agent infer_expression(?), "Expression".intern)
         inferers.put(agent infer_expcont(?), "ExpCont".intern)
         inferers.put(agent infer_booleanor(?), "BooleanOr".intern)
         inferers.put(agent infer_booleanorr(?), "BooleanOrR".intern)
         inferers.put(agent infer_booleanand(?), "BooleanAnd".intern)
         inferers.put(agent infer_booleanandr(?), "BooleanAndR".intern)
         inferers.put(agent infer_booleancomp(?), "BooleanComp".intern)
         inferers.put(agent infer_booleancompr(?), "BooleanCompR".intern)
         inferers.put(agent infer_expadd(?), "ExpAdd".intern)
         inferers.put(agent infer_expaddr(?), "ExpAddR".intern)
         inferers.put(agent infer_expmult(?), "ExpMult".intern)
         inferers.put(agent infer_expmultr(?), "ExpMultR".intern)
         inferers.put(agent infer_exppow(?), "ExpPow".intern)
         inferers.put(agent infer_exppowr(?), "ExpPowR".intern)
         inferers.put(agent infer_expatom(?), "ExpAtom".intern)
         inferers.put(agent infer_expcall(?), "ExpCall".intern)
         inferers.put(agent infer_expatomr(?), "ExpAtomR".intern)
         inferers.put(agent infer_addressable(?), "Addressable".intern)
      end


   infer_transformation (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(2).accept(Current)
         a_node.node(3).accept(Current)
         type := Void
      end

   infer_input (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         type := Void
      end

   infer_output (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         type := Void
      end

   infer_transform (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         type := Void
      end

   infer_instruction (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         type := Void
      end

   infer_assignorcall (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO: if assign, set addressable type
         type := Void
      end

   infer_aoccont (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         type := Void
      end

   infer_case (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         a_node.node(3).accept(Current)
         a_node.node(4).accept(Current)
         type := Void
      end

   infer_if (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         a_node.node(3).accept(Current)
         a_node.node(4).accept(Current)
         type := Void
      end

   infer_skip (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         type := Void
      end

   infer_when (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         type := Void
      end

   infer_then (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(3).accept(Current)
         type := Void
      end

   infer_elseif (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(2).accept(Current)
         type := Void
      end

   infer_else (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         if a_node.count > 0 then
            a_node.node(2).accept(Current)
         end
         type := Void
      end

   infer_expression (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
      end

   infer_expcont (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO: function call type inference
      end

   infer_booleanor (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(2).accept(Current)
      end

   infer_booleanorr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left_type, right_type: like type
      do
         if a_node.count > 0 then
            left_type := type
            a_node.node(2).accept(Current)
            right_type := type
            type := left_type.type_of("or", right_type)
            if type = Void then
               set_error(a_node, "Incompatible types: cannot 'or' #(1) and #(2) values" # left_type.name # right_type.name)
            end
         end
      end

   infer_booleanand (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(2).accept(Current)
      end

   infer_booleanandr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left_type, right_type: like type
      do
         if a_node.count > 0 then
            left_type := type
            a_node.node(2).accept(Current)
            right_type := type
            type := left_type.type_of("and", right_type)
            if type = Void then
               set_error(a_node, "Incompatible types: cannot 'and' #(1) and #(2) values" # left_type.name # right_type.name)
            end
         end
      end

   infer_booleancomp (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(2).accept(Current)
      end

   infer_booleancompr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left_type, right_type: like type; comparator: MIXUP_TRANSFORM_NODE_TERMINAL
      do
         if a_node.count > 0 then
            left_type := type
            a_node.node(2).accept(Current)
            right_type := type
            if left_type = Void or else right_type = Void then
               -- TODO: second pass
            elseif left_type = right_type then
               comparator ::= a_node.node(1)
               inspect
                  comparator.image.image
               when "=", "/=" then
                  type := type_boolean
               else
                  type := left_type.type_of(comparator.image.image, right_type)
                  if type = Void then
                     set_error(a_node.node(1), "#(1) values are not comparable" # left_type.name)
                  end
               end
            else
               set_error(a_node, "Cannot compare #(1) and #(2) values" # left_type.name # right_type.name)
            end
         end
      end

   infer_expadd (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(2).accept(Current)
      end

   infer_expaddr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left_type, right_type: like type; comparator: MIXUP_TRANSFORM_NODE_TERMINAL
      do
         if a_node.count > 0 then
            left_type := type
            a_node.node(2).accept(Current)
            right_type := type
            if left_type = Void or else right_type = Void then
               -- TODO: second pass
            elseif left_type = right_type then
               comparator ::= a_node.node(1)
               type := left_type.type_of(comparator.image.image, right_type)
               if type = Void then
                  set_error(a_node, "Cannot add or subtract #(1) and #(2) values" # left_type.name # right_type.name)
               end
            else
               set_error(a_node, "Cannot add or subtract #(1) and #(2) values" # left_type.name # right_type.name)
            end
         end
      end

   infer_expmult (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(2).accept(Current)
      end

   infer_expmultr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left_type, right_type: like type; comparator: MIXUP_TRANSFORM_NODE_TERMINAL
      do
         if a_node.count > 0 then
            left_type := type
            a_node.node(2).accept(Current)
            right_type := type
            if left_type = Void or else right_type = Void then
               -- TODO: second pass
            else
               comparator ::= a_node.node(1)
               type := left_type.type_of(comparator.image.image, right_type)
               if type = Void then
                  set_error(a_node.node(1), "Cannot multiply or divide divide #(1) values" # left_type.name)
               end
            end
         end
      end

   infer_exppow (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         a_node.node(1).accept(Current)
         a_node.node(2).accept(Current)
      end

   infer_exppowr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left_type, right_type: like type
      do
         if a_node.count > 0 then
            left_type := type
            a_node.node(2).accept(Current)
            right_type := type
            if left_type = Void or else right_type = Void then
               -- TODO: second pass
            else
               type := left_type.type_of("^", right_type)
               if type = Void then
                  set_error(a_node.node(1), "Cannot raise #(1) values to power #(2) values" # left_type.name # right_type.name)
               end
            end
         end
      end

   infer_expatom (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         first: MIXUP_TRANSFORM_NODE_TERMINAL
      do
         first ::= a_node.node(1)
         if first.name = kw_value then
            type := first.image.type
         elseif first.name = kw_identifier then
            -- TODO will need a second pass, depends on the type of
            -- the identifier
            a_node.node(2).accept(Current)
            a_node.node(3).accept(Current)
         else
            a_node.node(2).accept(Current)
         end
      end

   infer_expcall (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         if a_node.count > 0 then
            -- TODO function call type inference
            a_node.node(2).accept(Current)
         end
      end

   infer_expatomr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         if a_node.count > 0 then
            -- TODO
            a_node.node(2).accept(Current)
         end
      end

   infer_addressable (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO will need a second pass, depends on the type of
         -- the identifier
         a_node.node(2).accept(Current)
      end

   set_error (a_node: MIXUP_TRANSFORM_NODE; a_error: ABSTRACT_STRING)
      require
         a_node /= Void
         a_error /= Void
         error = Void
      do
         error := "#(1) at #(2)" # a_error # &a_node.start_position
      ensure
         error /= Void
      end

   type: MIXUP_TRANSFORM_NODE_TYPE

   inferers: HASHED_DICTIONARY[PROCEDURE[TUPLE[MIXUP_TRANSFORM_NODE_NON_TERMINAL]], FIXED_STRING]

   kw_value: FIXED_STRING once then "KW value".intern end
   kw_identifier: FIXED_STRING once then "KW identifier".intern end

end -- class MIXUP_TRANSFORM_INFERER
