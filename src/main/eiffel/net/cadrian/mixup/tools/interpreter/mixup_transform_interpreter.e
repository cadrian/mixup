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
   run

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
            visit(a_node.node(3))
            if error = Void then
               visit(a_node.node(4))
               if error = Void then
                  visit(a_node.node(2))
               end
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
      local
         output_node: MIXUP_TRANSFORM_NODE
         output_value: MIXUP_TRANSFORM_VALUE_IMPL[STRING]
      do
         check
            expression_stack.is_empty
         end
         output_node := a_node.node(2)
         visit(output_node)
         if error = Void then
            check
               expression_stack.count = 1
            end
            if expression_stack.last.type = type_string then
               output_value ::= expression_stack.last
               write_target_midi(output_node, output_value.value)
            else
               set_error(output_node, "Expected a string expression")
            end
            expression_stack.clear_count
         end
      ensure
         error = Void implies target_midi /= Void
      end

   write_target_midi (a_node: MIXUP_TRANSFORM_NODE; file: STRING)
      require
         error = Void
      local
         mid_out: BINARY_FILE_WRITE
         mid_tgt: MIXUP_MIDI_FILE_WRITE
      do
         log.trace.put_line("**** Writing target midi...")
         create mid_out.connect_to(file)
         if not mid_out.is_connected then
            log.error.put_line("Could not write file: #(2)" # file)
            die_with_code(1)
         end
         create mid_tgt.connect_to(mid_out)
         target_midi.encode_to(mid_tgt)
         mid_tgt.disconnect
      end

   run_init (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         if a_node.count = 2 then
            visit(a_node.node(2))
         end
      end

   run_transform (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         evt: MIXUP_TRANSFORM_VALUE_EVENT
      do
         log.trace.put_line("**** Running transformation...")
         prepare_target_midi
         check
            expression_stack.is_empty
         end
         create evt.make
         context.put(evt, "event")
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
         check
            expression_stack.is_empty
         end
      end

   prepare_target_midi
      local
         i: INTEGER
      do
         create target_midi.make(source_midi.division)
         from
            i := 1
         until
            i > source_midi.track_count
         loop
            target_midi.add_track(create {MIXUP_MIDI_TRACK}.make)
            i := i + 1
         end
      ensure
         target_midi /= Void
      end

   on_event (event: MIXUP_MIDI_CODEC; a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL): MIXUP_MIDI_CODEC
         -- a_node is the transform node (see `run_transform`)
      local
         evt: MIXUP_TRANSFORM_VALUE_EVENT
      do
         evt ::= context.at("event")
         evt.set_value(event)
         visit(a_node.node(2))
         evt ::= context.at("event")
         Result := evt.value
      end

feature {} -- Instruction
   run_instruction (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error= Void
         expression_stack.is_empty
      do
         visit(a_node.node(1))
      ensure
         error = Void implies expression_stack.is_empty
      end

   run_assignorcall (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         expression_stack.is_empty
      local
         ar: like aoc_runner
      do
         check
            aoc_runner = Void
         end
         visit(a_node.node(2))
         if error = Void then
            check
               aoc_runner /= Void
            end
            ar := aoc_runner
            visit(a_node.node(1))
            if error = Void then
               check
                  ar = aoc_runner
               end
               ar.run
               if ar.error /= Void then
                  set_error(a_node, ar.error)
               end
               aoc_runner := Void
            end
         end
      ensure
         error = Void implies expression_stack.is_empty
      end

   run_aoccont (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error = Void
         expression_stack.is_empty
      local
         first_node: MIXUP_TRANSFORM_NODE_TERMINAL
         assign_runner: MIXUP_TRANSFORM_ASSIGN_RUNNER
      do
         inspect
            a_node.count
         when 2 then
            first_node ::= a_node.node(1)
            check
               first_node.name = kw_assign
            end
            visit(a_node.node(2))
            if error = Void then
               create assign_runner.make(context, expression_stack.last)
               expression_stack.remove_last
               aoc_runner := assign_runner
            end
         when 3 then
            run_call_site(a_node, Void)
         end
      ensure
         error = Void implies aoc_runner /= Void
      end

   run_case (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error = Void
         expression_stack.is_empty
      do
         branch_stack.add_last(False)
         visit(a_node.node(2))
         if error = Void then
            visit(a_node.node(3))
         end
         if error = Void and then not branch_stack.last then
            expression_stack.remove_last
            visit(a_node.node(4))
         end
         if error = Void and then not branch_stack.last then
            set_error(a_node, "No branch taken")
         end
         branch_stack.remove_last
      ensure
         error = Void implies expression_stack.is_empty
      end

   run_if (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error = Void
         expression_stack.is_empty
      do
         branch_stack.add_last(False)
         visit(a_node.node(2))
         if error = Void and then not branch_stack.last then
            visit(a_node.node(3))
         end
         if error = Void and then not branch_stack.last then
            visit(a_node.node(4))
         end
         branch_stack.remove_last
      ensure
         error = Void implies expression_stack.is_empty
      end

   run_loop (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error = Void
         expression_stack.is_empty
      do
         from
            visit(a_node.node(2))
         until
            run_until(a_node.node(4))
         loop
            visit(a_node.node(6))
         end
      ensure
         error = Void implies expression_stack.is_empty
      end

   run_until (a_node: MIXUP_TRANSFORM_NODE): BOOLEAN
      local
         exp: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         if error /= Void then
            Result := True
         else
            visit(a_node)
            if error /= Void then
               Result := True
            elseif expression_stack.last.type = type_boolean then
               exp ::= expression_stack.last
               expression_stack.remove_last
               Result := exp.value
            else
               error := "invalid type: expected boolean instead of #(1)" # expression_stack.last.type.name
            end
         end
      end

   run_skip (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error = Void
         expression_stack.is_empty
      local
         evt: MIXUP_TRANSFORM_VALUE_EVENT
      do
         evt ::= context.at("event")
         evt.set_value(Void)
      ensure
         error = Void implies expression_stack.is_empty
      end

   run_when (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         exp: MIXUP_TRANSFORM_VALUE
      do
         if not branch_stack.last then
            visit(a_node.node(2))
            if error = Void then
               exp := expression_stack.last
               expression_stack.remove_last
               if expression_stack.last.type /= exp.type then
                  set_error(a_node.node(2), "invalid type: case #(1) vs. #(2)" # expression_stack.last.type.name # exp.type.name)
               elseif expression_stack.last.type.eq(expression_stack.last, exp) then
                  expression_stack.remove_last
                  visit(a_node.node(4))
                  branch_stack.put(True, branch_stack.upper)
               end
            end
         end
      end

   run_then (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error = Void
         expression_stack.is_empty
      local
         exp: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         visit(a_node.node(1))
         if error = Void then
            if expression_stack.last.type /= type_boolean then
               set_error(a_node.node(1), "expected boolean expression")
            else
               exp ::= expression_stack.last
               expression_stack.remove_last
               if exp.value then
                  visit(a_node.node(3))
                  branch_stack.put(True, branch_stack.upper)
               end
            end
         end
      ensure
         error = Void implies expression_stack.is_empty
      end

   run_elseif (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
         if not branch_stack.last then
            visit(a_node.node(2))
         end
      end

   run_else (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         error = Void
         expression_stack.is_empty
      do
         check not branch_stack.last end
         if a_node.count = 2 then
            visit(a_node.node(2))
            branch_stack.put(True, branch_stack.upper)
         end
      ensure
         error = Void implies expression_stack.is_empty
      end

feature {} -- Expression
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
            if error = Void then
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
            if error = Void then
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
            if error = Void then
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
            if error = Void then
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
            if error = Void then
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
         old_ar, ar: like aoc_runner
      do
         inspect
            a_node.count
         when 1 then
            first_node ::= a_node.node(1)
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
         when 2 then
            old_ar := aoc_runner
            aoc_runner := Void
            visit(a_node.node(2))
            if error = Void then
               check
                  aoc_runner /= Void
               end
               ar := aoc_runner
               visit(a_node.node(1))
               check
                  aoc_runner = ar
               end
               if error = Void then
                  ar.run
                  if ar.error /= Void then
                     set_error(a_node, ar.error)
                  end
               end
            end
            aoc_runner := old_ar
         when 3 then
            first_node ::= a_node.node(1)
            check
               first_node.name = kw_open_parenthesis
            end
            visit(a_node.node(2))
         end
      end

   run_expcall (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         entity_runner: MIXUP_TRANSFORM_ENTITY_RUNNER
      do
         inspect
            a_node.count
         when 0 then
            create entity_runner.make(context, agent push_expression(?))
            aoc_runner := entity_runner
         when 3 then
            run_call_site(a_node, agent push_expression(?))
         end
      ensure
         error = Void implies aoc_runner /= Void
      end

   push_expression (a_expression: MIXUP_TRANSFORM_VALUE)
      require
         a_expression /= Void
         a_expression.type /= type_unknown
      do
         expression_stack.add_last(a_expression)
      end

   run_call_site (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL; on_result: PROCEDURE[TUPLE[MIXUP_TRANSFORM_VALUE]])
      require
         a_node.count = 3
         a_node.node(1).name = kw_open_parenthesis
         a_node.node(3).name = kw_close_parenthesis
      local
         call_runner: MIXUP_TRANSFORM_CALL_RUNNER
         exp_count: INTEGER
      do
         exp_count := expression_stack.count
         visit(a_node.node(2))
         if error = Void then
            from
               create call_runner.make(context, expression_stack.count - exp_count, on_result)
            until
               expression_stack.count = exp_count
            loop
               call_runner.add_first(expression_stack.last)
               expression_stack.remove_last
            end
            aoc_runner := call_runner
         end
      ensure
         error = Void implies aoc_runner /= Void
      end

   run_expatomr (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         first_node: MIXUP_TRANSFORM_NODE_TERMINAL
         map: MIXUP_TRANSFORM_VALUE_ASSOCIATIVE
         index: MIXUP_TRANSFORM_VALUE
         ar: like aoc_runner
      do
         ar := aoc_runner
         inspect
            a_node.count
         when 0 then
         when 2 then
            first_node ::= a_node.node(1)
            check
               first_node.name = kw_dot
            end
            visit(a_node.node(2))
         when 4 then
            first_node ::= a_node.node(1)
            check
               first_node.name = kw_open_bracket
            end
            if ar /= Void then
               check
                  ar.error = Void
               end
               aoc_runner := Void
               visit(a_node.node(2))
               aoc_runner := ar
               if error = Void then
                  index := expression_stack.last
                  expression_stack.remove_last
                  ar.set_index(index)
                  visit(a_node.node(4))
               end
            elseif map ?:= expression_stack.last then
               map ::= expression_stack.last
               expression_stack.remove_last
               visit(a_node.node(2))
               if error = Void then
                  index := expression_stack.last
                  expression_stack.remove_last
                  if map.has_value(index) then
                     expression_stack.add_last(map.value(index))
                     visit(a_node.node(4))
                  else
                     set_error(a_node.node(2), "no such key")
                  end
               end
            else
               set_error(a_node, "expected an associative value")
            end
         end
      ensure
         aoc_runner = old aoc_runner
         aoc_runner /= Void implies (expression_stack.count = old expression_stack.count)
      end

   run_addressable (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      local
         identifier: MIXUP_TRANSFORM_NODE_TERMINAL
         tgt: MIXUP_TRANSFORM_VALUE
         ar: like aoc_runner
      do
         ar := aoc_runner
         identifier ::= a_node.node(1)
         check
            identifier.name = kw_identifier
         end
         if ar /= Void then
            check
               ar.error = Void
            end
            if ar.is_new then
               -- assign or call
               tgt := context.reference_at(identifier.image.image)
               create {MIXUP_TRANSFORM_VALUE_UNKNOWN} tgt.make(tgt, identifier.image.image)
               ar.set_target(tgt)
            else
               -- after a dot
               ar.set_field(identifier.image.image)
            end
         else
            -- after a dot, no aoc runner
            tgt := expression_stack.last
            expression_stack.remove_last
            if tgt.type.has_field(identifier.image.image) then
               expression_stack.add_last(tgt.type.field(identifier.image.image, tgt))
            else
               set_error(a_node, "unknown #(1) field: #(2)" # tgt.type.name # identifier.image.image)
            end
         end
         if error = Void then
            check
               ar = Void implies not expression_stack.is_empty
            end
            visit(a_node.node(2))
         end
      ensure
         aoc_runner = old aoc_runner
         aoc_runner /= Void implies (expression_stack.count = old expression_stack.count)
      end

feature {}
   run (a_root: MIXUP_TRANSFORM_NODE)
      require
         a_root /= Void
      do
         create_runners
         create expression_stack
         create branch_stack
         create context
         visit(a_root)
      end

   create_runners
      do
         create runners
         runners.put(agent run_transformation(?), nt_transformation)
         runners.put(agent run_input(?), nt_input)
         runners.put(agent run_output(?), nt_output)
         runners.put(agent run_init(?), nt_init)
         runners.put(agent run_transform(?), nt_transform)
         runners.put(agent run_instruction(?), nt_instruction)
         runners.put(agent run_assignorcall(?), nt_assignorcall)
         runners.put(agent run_aoccont(?), nt_aoccont)
         runners.put(agent run_case(?), nt_case)
         runners.put(agent run_if(?), nt_if)
         runners.put(agent run_loop(?), nt_loop)
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
   branch_stack: FAST_ARRAY[BOOLEAN]
   sequencer: MIXUP_TRANSFORM_SEQUENCER
   context: HASHED_DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]
   aoc_runner: MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER

   source_midi: MIXUP_MIDI_FILE
   target_midi: MIXUP_MIDI_FILE

feature {} -- keywords
   kw_value: FIXED_STRING once then "KW:value".intern end
   kw_identifier: FIXED_STRING once then "KW:identifier".intern end

   kw_and: FIXED_STRING once then "KW:and".intern end
   kw_case: FIXED_STRING once then "KW:case".intern end
   kw_power: FIXED_STRING once then "KW:^".intern end
   kw_less_or_equal: FIXED_STRING once then "KW:<=".intern end
   kw_less_than: FIXED_STRING once then "KW:<".intern end
   kw_equal: FIXED_STRING once then "KW:=".intern end
   kw_greater_or_equal: FIXED_STRING once then "KW:>=".intern end
   kw_greater_than: FIXED_STRING once then "KW:>".intern end
   kw_minus: FIXED_STRING once then "KW:-".intern end
   kw_coma: FIXED_STRING once then "KW:,".intern end
   kw_assign: FIXED_STRING once then "KW::=".intern end
   kw_not_equal: FIXED_STRING once then "KW:/=".intern end
   kw_divide: FIXED_STRING once then "KW:/".intern end
   kw_dot: FIXED_STRING once then "KW:.".intern end
   kw_open_parenthesis: FIXED_STRING once then "KW:(".intern end
   kw_close_parenthesis: FIXED_STRING once then "KW:)".intern end
   kw_open_bracket: FIXED_STRING once then "KW:[".intern end
   kw_close_bracket: FIXED_STRING once then "KW:]".intern end
   kw_times: FIXED_STRING once then "KW:*".intern end
   kw_plus: FIXED_STRING once then "KW:+".intern end
   kw_else: FIXED_STRING once then "KW:else".intern end
   kw_elseif: FIXED_STRING once then "KW:elseif".intern end
   kw_end: FIXED_STRING once then "KW:end".intern end
   kw_if: FIXED_STRING once then "KW:if".intern end
   kw_init: FIXED_STRING once then "KW:init".intern end
   kw_input: FIXED_STRING once then "KW:input".intern end
   kw_or: FIXED_STRING once then "KW:or".intern end
   kw_output: FIXED_STRING once then "KW:output".intern end
   kw_skip: FIXED_STRING once then "KW:skip".intern end
   kw_then: FIXED_STRING once then "KW:then".intern end
   kw_transform: FIXED_STRING once then "KW:transform".intern end
   kw_when: FIXED_STRING once then "KW:when".intern end
   kw_from: FIXED_STRING once then "KW:from".intern end
   kw_until: FIXED_STRING once then "KW:until".intern end
   kw_loop: FIXED_STRING once then "KW:loop".intern end

   nt_transformation: FIXED_STRING once then "Transformation".intern end
   nt_input: FIXED_STRING once then "Input".intern end
   nt_output: FIXED_STRING once then "Output".intern end
   nt_init: FIXED_STRING once then "Init".intern end
   nt_transform: FIXED_STRING once then "Transform".intern end
   nt_instruction: FIXED_STRING once then "Instruction".intern end
   nt_assignorcall: FIXED_STRING once then "AssignOrCall".intern end
   nt_aoccont: FIXED_STRING once then "AOCCont".intern end
   nt_case: FIXED_STRING once then "Case".intern end
   nt_if: FIXED_STRING once then "If".intern end
   nt_loop: FIXED_STRING once then "Loop".intern end
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
   branch_stack /= Void

end -- class MIXUP_TRANSFORM_INTERPRETER
