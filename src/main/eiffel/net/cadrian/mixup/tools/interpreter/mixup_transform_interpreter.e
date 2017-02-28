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
class MIXUP_TRANSFORM_INTERPRETER

inherit
   MIXUP_TRANSFORM_NODE_VISITOR

insert
   LOGGING
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM}
   make

feature {ANY}
   error: ABSTRACT_STRING

feature {MIXUP_TRANSFORM_NODE_TERMINAL}
   visit_terminal (a_node: MIXUP_TRANSFORM_NODE_TERMINAL)
      do
      end

feature {MIXUP_TRANSFORM_NODE_NON_TERMINAL}
   visit_non_terminal (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         if error = Void then
            runners.fast_at(a_node.name).call([a_node])
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
            visit(a_node.node(i))
            i := i + 1
         end
      end

feature {}
   run_transformation (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
         if error = Void then
            visit(a_node.node(2))
            if error = Void then
               visit(a_node.node(3))
            end
         end
      end

   run_input (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         input_node: MIXUP_TRANSFORM_NODE
         input_value: MIXUP_TRANSFORM_VALUE_IMPL[STRING]
      do
         check
            expression_stack.is_empty
         end
         input_node := a_node.node(2)
         visit(input_node)
         if error = Void then
            check
               expression_stack.count = 1
            end
            if expression_stack.last.type = type_string then
               input_value ::= expression_stack.last
               read_source_midi(input_node, input_value.value)
            else
               set_error(input_node, "Expected a string expression")
            end
            expression_stack.clear_count
         end
      ensure
         error = Void implies source_midi /= Void
      end

   read_source_midi (a_node: MIXUP_TRANSFORM_NODE; file: STRING)
      require
         error = Void
      local
         mid_in: BINARY_FILE_READ
         mid_src: MIXUP_MIDI_FILE_READ
      do
         log.trace.put_line("**** Reading source midi: #(1)" # file)
         create mid_in.connect_to(file)
         if not mid_in.is_connected then
            set_error(a_node, "File not found: #(1)" # file)
         else
            create mid_src.connect_to(mid_in)
            check
               mid_src.is_connected
            end
            mid_src.decode
            if mid_src.has_error then
               mid_src.disconnect
               set_error(a_node, "Error while reading MIDI file: #(1)" # mid_src.error)
            else
               source_midi := mid_src.decoded
               check
                  source_midi /= Void
               end
               log.info.put_line("MIDI file has #(1) #(2)" # &(source_midi.track_count)
                                 # (if source_midi.track_count = 1 then "track" else "tracks" end))
               mid_src.disconnect
               source_midi.end_all_tracks
               log.trace.put_line("max time: #(1)" # &(source_midi.max_time))
            end
         end
      ensure
         error = Void implies source_midi /= Void
      end

   run_output (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         check
            expression_stack.is_empty
         end
         -- TODO
      ensure
         error = Void implies target_midi /= Void
      end

   run_transform (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         check
            expression_stack.is_empty
         end
         create sequencer.make(agent on_event(?, a_node), source_midi)
         from
            sequencer.start
         until
            sequencer.is_off
         loop
            target_midi.track(sequencer.track_index).add_event(sequencer.time, sequencer.event)
            sequencer.next
         end
         target_midi.end_all_tracks
      end

   on_event (event: MIXUP_MIDI_CODEC; a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL): MIXUP_MIDI_CODEC
      do
         -- TODO
      end

   run_instruction (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_assignorcall (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_aoccont (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_case (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_if (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_skip (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_when (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_then (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_elseif (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_else (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_expression (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
      ensure
         error = Void implies expression_stack.count = old expression_stack.count + 1
      end

   run_booleanor (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
         if error = Void then
            visit(a_node.node(2))
         end
      end

   run_booleanorr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left, right, res: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         if a_node.count > 0 then
            check
               expression_stack.count >= 1
            end
            visit(a_node.node(2))
            check
               expression_stack.count >= 2
            end
            if expression_stack.last.type /= type_boolean or else expression_stack.item(expression_stack.upper-1).type /= type_boolean then
               set_error(a_node, "Expected boolean")
            else
               right ::= expression_stack.last
               expression_stack.remove_last
               left ::= expression_stack.last
               expression_stack.remove_last
               create res.make
               res.set_value(left.value or right.value)
               expression_stack.add_last(res)
            end
         end
      end

   run_booleanand (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
         if error = Void then
            visit(a_node.node(2))
         end
      end

   run_booleanandr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left, right, res: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         if a_node.count > 0 then
            check
               expression_stack.count >= 1
            end
            visit(a_node.node(2))
            check
               expression_stack.count >= 2
            end
            if expression_stack.last.type /= type_boolean or else expression_stack.item(expression_stack.upper-1).type /= type_boolean then
               set_error(a_node, "Expected boolean")
            else
               right ::= expression_stack.last
               expression_stack.remove_last
               left ::= expression_stack.last
               expression_stack.remove_last
               create res.make
               res.set_value(left.value and right.value)
               expression_stack.add_last(res)
            end
         end
      end

   run_booleancomp (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
         if error = Void then
            visit(a_node.node(2))
         end
      end

   run_booleancompr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left, right: MIXUP_TRANSFORM_VALUE
         res: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         if a_node.count > 0 then
            check
               expression_stack.count >= 1
            end
            visit(a_node.node(2))
            check
               expression_stack.count >= 2
            end
            right := expression_stack.last
            expression_stack.remove_last
            left := expression_stack.last
            expression_stack.remove_last
            create res.make
            res.set_value(compare(a_node, left, right, a_node.node(1).name))
            expression_stack.add_last(res)
         end
      end

   compare (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL; left, right: MIXUP_TRANSFORM_VALUE; operator_kw: FIXED_STRING): BOOLEAN
      do
         if left.type /= right.type then
            set_error(a_node, "Left and right operands must have the same type")
         elseif operator_kw = kw_equal then
            Result := left.type.eq(left, right)
         elseif operator_kw = kw_not_equal then
            Result := not left.type.eq(left, right)
         elseif not left.type.is_comparable then
            set_error(a_node, "Types are not comparable")
         elseif operator_kw = kw_greater_or_equal then
            Result := not right.type.gt(right, left)
         elseif operator_kw = kw_greater_than then
            Result := left.type.gt(left, right)
         elseif operator_kw = kw_less_or_equal then
            Result := not left.type.gt(left, right)
         elseif operator_kw = kw_less_than then
            Result := right.type.gt(right, left)
         else
            check False end
         end
      end

   run_expadd (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
         if error = Void then
            visit(a_node.node(2))
         end
      end

   run_expaddr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left, right, res: MIXUP_TRANSFORM_VALUE
      do
         if a_node.count > 0 then
            check
               expression_stack.count >= 1
            end
            visit(a_node.node(2))
            check
               expression_stack.count >= 2
            end
            right := expression_stack.last
            expression_stack.remove_last
            left := expression_stack.last
            expression_stack.remove_last
            res := add(a_node, left, right, a_node.node(1).name)
            if res = Void then
               set_error(a_node, "Invalid expression")
            else
               expression_stack.add_last(res)
            end
         end
      end

   add (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL; left, right: MIXUP_TRANSFORM_VALUE; operator_kw: FIXED_STRING): MIXUP_TRANSFORM_VALUE
      do
         if operator_kw = kw_plus then
            Result := left.type.add(left, right)
            if Result = Void then
               set_error(a_node, left.type.error)
            end
         elseif operator_kw = kw_minus then
            Result := left.type.subtract(left, right)
            if Result = Void then
               set_error(a_node, left.type.error)
            end
         else
            check False end
         end
      end

   run_expmult (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
         if error = Void then
            visit(a_node.node(2))
         end
      end

   run_expmultr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left, right, res: MIXUP_TRANSFORM_VALUE
      do
         if a_node.count > 0 then
            check
               expression_stack.count >= 1
            end
            visit(a_node.node(2))
            check
               expression_stack.count >= 2
            end
            right := expression_stack.last
            expression_stack.remove_last
            left := expression_stack.last
            expression_stack.remove_last
            res := mult(a_node, left, right, a_node.node(1).name)
            if res = Void then
               set_error(a_node, "Invalid expression")
            else
               expression_stack.add_last(res)
            end
         end
      end

   mult (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL; left, right: MIXUP_TRANSFORM_VALUE; operator_kw: FIXED_STRING): MIXUP_TRANSFORM_VALUE
      do
         if operator_kw = kw_times then
            Result := left.type.multiply(left, right)
            if Result = Void then
               set_error(a_node, left.type.error)
            end
         elseif operator_kw = kw_divide then
            Result := left.type.divide(left, right)
            if Result = Void then
               set_error(a_node, left.type.error)
            end
         else
            check False end
         end
      end

   run_exppow (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         visit(a_node.node(1))
         if error = Void then
            visit(a_node.node(2))
         end
      end

   run_exppowr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         left, right, res: MIXUP_TRANSFORM_VALUE
      do
         if a_node.count > 0 then
            check
               expression_stack.count >= 1
            end
            visit(a_node.node(2))
            check
               expression_stack.count >= 2
            end
            right := expression_stack.last
            expression_stack.remove_last
            left := expression_stack.last
            expression_stack.remove_last
            res := pow(a_node, left, right, a_node.node(1).name)
            if res = Void then
               set_error(a_node, "Invalid expression")
            else
               expression_stack.add_last(res)
            end
         end
      end

   pow (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL; left, right: MIXUP_TRANSFORM_VALUE; operator_kw: FIXED_STRING): MIXUP_TRANSFORM_VALUE
      do
         if operator_kw = kw_power then
            Result := left.type.power(left, right)
            if Result = Void then
               set_error(a_node, left.type.error)
            end
         else
            check False end
         end
      end

   run_expatom (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         value: MIXUP_TRANSFORM_VALUE
         first_node: MIXUP_TRANSFORM_NODE_TERMINAL
      do
         first_node ::= a_node.node(1)
         if a_node.count = 1 then
            check
               first_node.name = kw_value
            end
            value := first_node.image.type.value_of(first_node.image)
            if value = Void then
               if first_node.image.type.error /= Void then
                  set_error(a_node, first_node.image.type.error)
               else
                  set_error(a_node, "Bad value: void")
               end
            else
               expression_stack.add_last(value)
            end
         elseif first_node.name = kw_identifier then
            value := context.reference_at(first_node.image.image)
            if value = Void then
               set_error(a_node, "Unknown identifier: #(1)" # first_node.image.image)
            else
               expression_stack.add_last(value)
               visit(a_node.node(2))
               if error = Void then
                  visit(a_node.node(3))
               end
            end
         else
            visit(a_node.node(2))
         end
      end

   run_expcall (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_expatomr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

   run_addressable (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         -- TODO
      end

feature {}
   make (a_root: MIXUP_TRANSFORM_NODE)
      require
         a_root /= Void
      do
         create_runners
         create expression_stack
         create context
         visit(a_root)
      end

   create_runners
      do
         create runners
         runners.put(agent run_transformation(?), nt_transformation)
         runners.put(agent run_input(?), nt_input)
         runners.put(agent run_output(?), nt_output)
         runners.put(agent run_transform(?), nt_transform)
         runners.put(agent run_instruction(?), nt_instruction)
         runners.put(agent run_assignorcall(?), nt_assignorcall)
         runners.put(agent run_aoccont(?), nt_aoccont)
         runners.put(agent run_case(?), nt_case)
         runners.put(agent run_if(?), nt_if)
         runners.put(agent run_skip(?), nt_skip)
         runners.put(agent run_when(?), nt_when)
         runners.put(agent run_then(?), nt_then)
         runners.put(agent run_elseif(?), nt_elseif)
         runners.put(agent run_else(?), nt_else)
         runners.put(agent run_expression(?), nt_expression)
         runners.put(agent run_booleanor(?), nt_booleanor)
         runners.put(agent run_booleanorr(?), nt_booleanorr)
         runners.put(agent run_booleanand(?), nt_booleanand)
         runners.put(agent run_booleanandr(?), nt_booleanandr)
         runners.put(agent run_booleancomp(?), nt_booleancomp)
         runners.put(agent run_booleancompr(?), nt_booleancompr)
         runners.put(agent run_expadd(?), nt_expadd)
         runners.put(agent run_expaddr(?), nt_expaddr)
         runners.put(agent run_expmult(?), nt_expmult)
         runners.put(agent run_expmultr(?), nt_expmultr)
         runners.put(agent run_exppow(?), nt_exppow)
         runners.put(agent run_exppowr(?), nt_exppowr)
         runners.put(agent run_expatom(?), nt_expatom)
         runners.put(agent run_expcall(?), nt_expcall)
         runners.put(agent run_expatomr(?), nt_expatomr)
         runners.put(agent run_addressable(?), nt_addressable)
      end

   visit (a_node: MIXUP_TRANSFORM_NODE)
      do
         a_node.accept(Current)
      end

   set_error (a_node: MIXUP_TRANSFORM_NODE; a_error: ABSTRACT_STRING)
      require
         a_node /= Void
         a_error /= Void
         error = Void
      do
         sedb_breakpoint
         error := "#(1) at #(2)" # a_error # &a_node.start_position
      ensure
         error /= Void
      end

   runners: HASHED_DICTIONARY[PROCEDURE[TUPLE[MIXUP_TRANSFORM_NODE_NON_TERMINAL]], FIXED_STRING]
   expression_stack: FAST_ARRAY[MIXUP_TRANSFORM_VALUE]
   sequencer: MIXUP_TRANSFORM_SEQUENCER
   context: HASHED_DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]

   source_midi: MIXUP_MIDI_FILE
   target_midi: MIXUP_MIDI_FILE

   kw_value: FIXED_STRING once then "KW value".intern end
   kw_identifier: FIXED_STRING once then "KW identifier".intern end

   kw_and: FIXED_STRING once then "KW and".intern end
   kw_case: FIXED_STRING once then "KW case".intern end
   kw_power: FIXED_STRING once then "KW ^".intern end
   kw_less_or_equal: FIXED_STRING once then "KW <=".intern end
   kw_less_than: FIXED_STRING once then "KW <".intern end
   kw_equal: FIXED_STRING once then "KW =".intern end
   kw_greater_or_equal: FIXED_STRING once then "KW >=".intern end
   kw_greater_than: FIXED_STRING once then "KW >".intern end
   kw_minus: FIXED_STRING once then "KW -".intern end
   kw_coma: FIXED_STRING once then "KW ,".intern end
   kw_assign: FIXED_STRING once then "KW :=".intern end
   kw_not_equal: FIXED_STRING once then "KW /=".intern end
   kw_divide: FIXED_STRING once then "KW /".intern end
   kw_dot: FIXED_STRING once then "KW .".intern end
   kw_open_parenthesis: FIXED_STRING once then "KW (".intern end
   kw_close_parenthesis: FIXED_STRING once then "KW )".intern end
   kw_open_bracket: FIXED_STRING once then "KW [".intern end
   kw_close_bracket: FIXED_STRING once then "KW ]".intern end
   kw_times: FIXED_STRING once then "KW *".intern end
   kw_plus: FIXED_STRING once then "KW +".intern end
   kw_else: FIXED_STRING once then "KW else".intern end
   kw_elseif: FIXED_STRING once then "KW elseif".intern end
   kw_end: FIXED_STRING once then "KW end".intern end
   kw_if: FIXED_STRING once then "KW if".intern end
   kw_input: FIXED_STRING once then "KW input".intern end
   kw_or: FIXED_STRING once then "KW or".intern end
   kw_output: FIXED_STRING once then "KW output".intern end
   kw_skip: FIXED_STRING once then "KW skip".intern end
   kw_then: FIXED_STRING once then "KW then".intern end
   kw_transform: FIXED_STRING once then "KW transform".intern end
   kw_when: FIXED_STRING once then "KW when".intern end

   nt_transformation: FIXED_STRING once then "Transformation".intern end
   nt_input: FIXED_STRING once then "Input".intern end
   nt_output: FIXED_STRING once then "Output".intern end
   nt_transform: FIXED_STRING once then "Transform".intern end
   nt_instruction: FIXED_STRING once then "Instruction".intern end
   nt_assignorcall: FIXED_STRING once then "AssignOrCall".intern end
   nt_aoccont: FIXED_STRING once then "AOCCont".intern end
   nt_case: FIXED_STRING once then "Case".intern end
   nt_if: FIXED_STRING once then "If".intern end
   nt_skip: FIXED_STRING once then "Skip".intern end
   nt_when: FIXED_STRING once then "When".intern end
   nt_then: FIXED_STRING once then "Then".intern end
   nt_elseif: FIXED_STRING once then "ElseIf".intern end
   nt_else: FIXED_STRING once then "Else".intern end
   nt_expression: FIXED_STRING once then "Expression".intern end
   nt_booleanor: FIXED_STRING once then "BooleanOr".intern end
   nt_booleanorr: FIXED_STRING once then "BooleanOrR".intern end
   nt_booleanand: FIXED_STRING once then "BooleanAnd".intern end
   nt_booleanandr: FIXED_STRING once then "BooleanAndR".intern end
   nt_booleancomp: FIXED_STRING once then "BooleanComp".intern end
   nt_booleancompr: FIXED_STRING once then "BooleanCompR".intern end
   nt_expadd: FIXED_STRING once then "ExpAdd".intern end
   nt_expaddr: FIXED_STRING once then "ExpAddR".intern end
   nt_expmult: FIXED_STRING once then "ExpMult".intern end
   nt_expmultr: FIXED_STRING once then "ExpMultR".intern end
   nt_exppow: FIXED_STRING once then "ExpPow".intern end
   nt_exppowr: FIXED_STRING once then "ExpPowR".intern end
   nt_expatom: FIXED_STRING once then "ExpAtom".intern end
   nt_expcall: FIXED_STRING once then "ExpCall".intern end
   nt_expatomr: FIXED_STRING once then "ExpAtomR".intern end
   nt_addressable: FIXED_STRING once then "Addressable".intern end

invariant
   runners /= Void
   expression_stack /= Void

end -- class MIXUP_TRANSFORM_INTERPRETER
