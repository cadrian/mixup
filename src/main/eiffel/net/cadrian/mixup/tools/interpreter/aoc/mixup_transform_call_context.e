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
class MIXUP_TRANSFORM_CALL_CONTEXT

insert
   MIXUP_TRANSFORM_TYPES

create {MIXUP_TRANSFORM_CALL}
   make

feature {ANY} -- target
   has_target: BOOLEAN
      do
         Result := target /= Void
      end

   target_is_numeric: BOOLEAN
      require
         has_target
      do
         Result := target.type = type_numeric
      end

   target_numeric: INTEGER
      require
         has_target
         target_is_numeric
      local
         v: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         v ::= target
         Result := v.value
      end

   target_is_string: BOOLEAN
      require
         has_target
      do
         Result := target.type = type_string
      end

   target_string: STRING
      require
         has_target
         target_is_string
      local
         v: MIXUP_TRANSFORM_VALUE_STRING
      do
         v ::= target
         Result := v.value
      end

   target_is_event: BOOLEAN
      require
         has_target
      do
         Result := target.type = type_event
      end

   target_event: MIXUP_MIDI_CODEC
      require
         has_target
         target_is_event
      local
         v: MIXUP_TRANSFORM_VALUE_EVENT
      do
         v ::= target
         Result := v.value
      end

   target_is_boolean: BOOLEAN
      require
         has_target
      do
         Result := target.type = type_boolean
      end

   target_boolean: BOOLEAN
      require
         has_target
         target_is_boolean
      local
         v: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         v ::= target
         Result := v.value
      end

feature {ANY} -- arguments
   argument_count: INTEGER
      do
         Result := arguments.count
      end

   argument_is_numeric (i: INTEGER): BOOLEAN
      require
         i.in_range(1, argument_count)
      do
         Result := arguments.item(arguments.upper - i + 1).type = type_numeric
      end

   argument_numeric (i: INTEGER): INTEGER
      require
         i.in_range(1, argument_count)
         argument_is_numeric(i)
      local
         v: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         v ::= arguments.item(arguments.upper - i + 1)
         Result := v.value
      end

   argument_is_string (i: INTEGER): BOOLEAN
      require
         i.in_range(1, argument_count)
      do
         Result := arguments.item(arguments.upper - i + 1).type = type_string
      end

   argument_string (i: INTEGER): STRING
      require
         i.in_range(1, argument_count)
         argument_is_string(i)
      local
         v: MIXUP_TRANSFORM_VALUE_STRING
      do
         v ::= arguments.item(arguments.upper - i + 1)
         Result := v.value
      end

   argument_is_event (i: INTEGER): BOOLEAN
      require
         i.in_range(1, argument_count)
      do
         Result := arguments.item(arguments.upper - i + 1).type = type_event
      end

   argument_event (i: INTEGER): MIXUP_MIDI_CODEC
      require
         i.in_range(1, argument_count)
         argument_is_event(i)
      local
         v: MIXUP_TRANSFORM_VALUE_EVENT
      do
         v ::= arguments.item(arguments.upper - i + 1)
         Result := v.value
      end

   argument_is_boolean (i: INTEGER): BOOLEAN
      require
         i.in_range(1, argument_count)
      do
         Result := arguments.item(arguments.upper - i + 1).type = type_boolean
      end

   argument_boolean (i: INTEGER): BOOLEAN
      require
         i.in_range(1, argument_count)
         argument_is_boolean(i)
      local
         v: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         v ::= arguments.item(arguments.upper - i + 1)
         Result := v.value
      end

feature {}
   make (a_target: like target; a_arguments: like arguments)
      require
         a_arguments /= Void
      do
         target := a_target
         arguments := a_arguments
      ensure
         target = a_target
         arguments = a_arguments
         target /= Void implies has_target
         a_arguments.count = argument_count
      end

   target: MIXUP_TRANSFORM_VALUE
   arguments: TRAVERSABLE[MIXUP_TRANSFORM_VALUE]

invariant
   arguments /= Void

end -- class MIXUP_TRANSFORM_CALL_CONTEXT
