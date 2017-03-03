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
      do
         check
            error = Void
            a_target.target.type = type_unknown
         end
         u ::= a_target.target
         inspect
            u.name
         when "note_on" then
            run_note_on
         when "note_off" then
            run_note_off
         else
            if on_result = Void then
               error := "unknown procedure: #(1)" # u.name
            else
               error := "unknown function: #(1)" # u.name
            end
         end
      end

feature {}
   run_note_on
         -- note_on(channel, pitch, velocity)
      local
         channel, pitch, velocity: MIXUP_TRANSFORM_VALUE_NUMERIC
         event: MIXUP_TRANSFORM_VALUE_EVENT
         note_on: MIXUP_MIDI_NOTE_ON
      do
         if count /= 3 then
            error := "invalid argument number: expect 3 arguments"
         else
            channel := arg_numeric(1)
            if error = Void then
               pitch := arg_numeric(2)
               if error = Void then
                  velocity := arg_numeric(3)
                  if error = Void then
                     if not channel.value.in_range(0, 15) then
                        error := "invalid channel: #(1)" # &channel.value
                     elseif pitch.value < 0 then
                        error := "invalid pitch: #(1)" # &pitch.value
                     elseif velocity.value < 0 then
                        error := "invalid velocity: #(1)" # &velocity.value
                     else
                        create note_on.make(channel.value, pitch.value, velocity.value)
                        create event.make
                        event.set_value(note_on)
                        result_value := event
                     end
                  end
               end
            end
         end
      end

   run_note_off
         -- note_off(channel, pitch, velocity)
      local
         channel, pitch, velocity: MIXUP_TRANSFORM_VALUE_NUMERIC
         event: MIXUP_TRANSFORM_VALUE_EVENT
         note_off: MIXUP_MIDI_NOTE_OFF
      do
         if count /= 3 then
            error := "invalid argument number: expect 3 arguments"
         else
            channel := arg_numeric(1)
            if error = Void then
               pitch := arg_numeric(2)
               if error = Void then
                  velocity := arg_numeric(3)
                  if error = Void then
                     if not channel.value.in_range(0, 15) then
                        error := "invalid channel: #(1)" # &channel.value
                     elseif pitch.value < 0 then
                        error := "invalid pitch: #(1)" # &pitch.value
                     elseif velocity.value < 0 then
                        error := "invalid velocity: #(1)" # &velocity.value
                     else
                        create note_off.make(channel.value, pitch.value, velocity.value)
                        create event.make
                        event.set_value(note_off)
                        result_value := event
                     end
                  end
               end
            end
         end
      end

   arg_numeric (i: INTEGER): MIXUP_TRANSFORM_VALUE_NUMERIC
      local
         v: MIXUP_TRANSFORM_VALUE
      do
         v := item(i)
         if v.type = type_numeric then
            Result ::= v
         else
            error := "invalid argument #(1): expected numeric" # &i
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
