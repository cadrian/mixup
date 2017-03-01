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
class MIXUP_TRANSFORM_TYPE_EVENT

inherit
   MIXUP_TRANSFORM_TYPE_IMPL[MIXUP_MIDI_CODEC]

create {MIXUP_TRANSFORM_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN False

feature {MIXUP_TRANSFORM_TYPES}
   init
      do
      end

feature {MIXUP_TRANSFORM_INTERPRETER, MIXUP_TRANSFORM_TYPE, MIXUP_TRANSFORM_VALUE}
   eq (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      local
         l, r: MIXUP_TRANSFORM_VALUE_EVENT
      do
         l ::= left
         r ::= right
         Result := l.value.is_equal(r.value)
      end

   gt (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      do
         set_error("internal error: unexpected call")
      end

   add (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot add events")
         else
            set_error("cannot add event and #(1)" # right.type.name)
         end
      end

   subtract (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot subtract events")
         else
            set_error("cannot subtract event and #(1)" # right.type.name)
         end
      end

   multiply (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot multiply events")
         else
            set_error("cannot multiply event and #(1)" # right.type.name)
         end
      end

   divide (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot divide events")
         else
            set_error("cannot divide event and #(1)" # right.type.name)
         end
      end

   power (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot take power of events")
         else
            set_error("cannot take power of event by #(1)" # right.type.name)
         end
      end

feature {ANY}
   has_field (field_name: STRING): BOOLEAN
      do
         inspect
            field_name
         when "velocity", "channel", "pitch", "meta", "value", "fine", "type" then
            Result := True
         else
            check not Result end
         end
      end

   field (field_name: STRING; target: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         t: MIXUP_TRANSFORM_VALUE_EVENT
      do
         inspect
            field_name
         when "velocity", "channel", "pitch", "meta", "value", "fine", "type" then
            t ::= target
            Result := field_getter.item(t.value, field_name)
            if Result = Void then
               sedb_breakpoint
               set_error("unknown field: #(1)" # field_name)
            end
         else
            set_error("internal error: unexpected call")
         end
      end

   value_of (image: MIXUP_TRANSFORM_NODE_IMAGE): MIXUP_TRANSFORM_VALUE
      do
         set_error("internal error: invalid type")
      end

   new_value: MIXUP_TRANSFORM_VALUE
      do
         create {MIXUP_TRANSFORM_VALUE_EVENT} Result.make
      end

feature {}
   field_getter: MIXUP_TRANSFORM_EVENT_FIELD_GETTER
      once
         create Result.make
      end

end -- class MIXUP_TRANSFORM_TYPE_EVENT
