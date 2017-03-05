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
class MIXUP_TRANSFORM_CALL_RUNNER

inherit
   MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER
   MIXUP_TRANSFORM_AOC_EXPRESSION_VISITOR

insert
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM_INTERPRETER}
   make

feature {ANY}
   count: INTEGER then arguments.count
      end

   capacity: INTEGER then arguments.capacity
      end

   item (i: INTEGER): MIXUP_TRANSFORM_VALUE
      require
         count = capacity
         i.in_range(1, count)
      do
         Result := arguments.item(count - i)
      ensure
         Result /= Void
      end

feature {MIXUP_TRANSFORM_INTERPRETER}
   run
      local
         i: INTEGER
      do
         from
            i := expression_string.lower
         until
            error /= Void or else i > expression_string.upper
         loop
            expression_string.item(i).accept(Current)
            i := i + 1
         end
         if error = Void then
            if on_result = Void then
               if result_value = Void then
                  -- OK
               else
                  error := "function has a result (not a procedure)"
               end
            else
               if result_value = Void then
                  error := "procedure does not have a result (not a function)"
               else
                  on_result.call([result_value])
               end
            end
         end
      end

feature {MIXUP_TRANSFORM_AOC_FIELD}
   visit_field (a_field: MIXUP_TRANSFORM_AOC_FIELD)
      do
         check
            error = Void
         end
         error := "not yet implemented"
      end

feature {MIXUP_TRANSFORM_AOC_INDEX}
   visit_index (a_index: MIXUP_TRANSFORM_AOC_INDEX)
      do
         check
            error = Void
         end
         error := "not yet implemented"
      end

feature {MIXUP_TRANSFORM_AOC_TARGET}
   visit_target (a_target: MIXUP_TRANSFORM_AOC_TARGET)
      local
         u: MIXUP_TRANSFORM_VALUE_UNKNOWN
         calls: MIXUP_TRANSFORM_CALLS
         f: TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
      do
         check
            error = Void
            a_target.target.type = type_unknown
         end
         u ::= a_target.target
         if on_result = Void then
            error := calls.call_procedure(u.name, Void, arguments)
         else
            f := calls.call_function(u.name, Void, arguments)
            if f.second /= Void then
               error := f.second
            else
               result_value := f.first
            end
         end
      end

feature {MIXUP_TRANSFORM_INTERPRETER}
   add_first (value: MIXUP_TRANSFORM_VALUE)
      require
         count < capacity
         value /= Void
      do
         arguments.add_last(value)
      ensure
         count = old count + 1
         capacity = old capacity
      end

feature {}
   make (a_context: like context; a_capacity: INTEGER; a_on_result: like on_result)
      require
         a_context /= Void
         a_capacity >= 0
      do
         context := a_context
         on_result := a_on_result
         create arguments.with_capacity(a_capacity)
         create expression_string
      ensure
         context = a_context
         on_result = a_on_result
         capacity = a_capacity
      end

   context: DICTIONARY[MIXUP_TRANSFORM_VALUE, STRING]

   arguments: FAST_ARRAY[MIXUP_TRANSFORM_VALUE]
         -- BEWARE: stored in reverse order!

   result_value: MIXUP_TRANSFORM_VALUE

   on_result: PROCEDURE[TUPLE[MIXUP_TRANSFORM_VALUE]]
         -- If non Void, this is a function call and a result is expected.
         -- If Void, this is a procedure call and there must not be a result.

invariant
   arguments /= Void

end -- class MIXUP_TRANSFORM_CALL_RUNNER
