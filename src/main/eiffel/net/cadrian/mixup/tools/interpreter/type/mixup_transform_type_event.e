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
      local
         calls: MIXUP_TRANSFORM_CALLS
      do
         calls.register_function("note_on",
                                 Void, {FAST_ARRAY[MIXUP_TRANSFORM_TYPE] << type_numeric, type_numeric, type_numeric >>}, Current,
                                 agent new_note_on(?))
         calls.register_function("note_off",
                                 Void, {FAST_ARRAY[MIXUP_TRANSFORM_TYPE] << type_numeric, type_numeric, type_numeric >>}, Current,
                                 agent new_note_off(?))
         calls.register_function("utf_to_iso",
                                 Void, {FAST_ARRAY[MIXUP_TRANSFORM_TYPE] << type_string >>}, type_string,
                                 agent utf_to_iso(?))
         calls.register_function("text_event",
                                 Void, {FAST_ARRAY[MIXUP_TRANSFORM_TYPE] << type_string >>}, Current,
                                 agent new_text_event(?))
      end

feature {}
   new_note_on (context: MIXUP_TRANSFORM_CALL_CONTEXT): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
         -- note_on(channel, pitch, velocity)
      require
         context.argument_count = 3
         context.argument_is_numeric(1)
         context.argument_is_numeric(2)
         context.argument_is_numeric(3)
      local
         channel, pitch, velocity: INTEGER
         event: MIXUP_TRANSFORM_VALUE_EVENT
         note_on: MIXUP_MIDI_NOTE_ON
         err: ABSTRACT_STRING
      do
         channel := context.argument_numeric(1)
         pitch := context.argument_numeric(2)
         velocity := context.argument_numeric(3)
         if not channel.in_range(0, 15) then
            err := "invalid channel: #(1)" # &channel
         elseif pitch < 0 then
            err := "invalid pitch: #(1)" # &pitch
         elseif velocity < 0 then
            err := "invalid velocity: #(1)" # &velocity
         else
            create note_on.make(channel, pitch, velocity)
            create event.make
            event.set_value(note_on)
         end
         Result := [event, err]
      end

   new_note_off (context: MIXUP_TRANSFORM_CALL_CONTEXT): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
         -- note_off(channel, pitch, velocity)
      require
         context.argument_count = 3
         context.argument_is_numeric(1)
         context.argument_is_numeric(2)
         context.argument_is_numeric(3)
      local
         channel, pitch, velocity: INTEGER
         event: MIXUP_TRANSFORM_VALUE_EVENT
         note_off: MIXUP_MIDI_NOTE_OFF
         err: ABSTRACT_STRING
      do
         channel := context.argument_numeric(1)
         pitch := context.argument_numeric(2)
         velocity := context.argument_numeric(3)
         if not channel.in_range(0, 15) then
            err := "invalid channel: #(1)" # &channel
         elseif pitch < 0 then
            err := "invalid pitch: #(1)" # &pitch
         elseif velocity < 0 then
            err := "invalid velocity: #(1)" # &velocity
         else
            create note_off.make(channel, pitch, velocity)
            create event.make
            event.set_value(note_off)
         end
         Result := [event, err]
      end

   utf_to_iso (context: MIXUP_TRANSFORM_CALL_CONTEXT): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
         -- note_off(channel, pitch, velocity)
      require
         context.argument_count = 1
         context.argument_is_string(1)
      local
         utf, iso: STRING
         conv: MIXUP_STRING_CONVERSION
         str: MIXUP_TRANSFORM_VALUE_STRING
         err: ABSTRACT_STRING
      do
         utf := context.argument_string(1)
         iso := conv.utf8_to_iso(utf, conv.Format_iso_8859_15)
         if iso = Void then
            err := "invalid UTF-8 string"
         else
            create str.make
            str.set_value(iso)
         end
         Result := [str, err]
      end

   new_text_event (context: MIXUP_TRANSFORM_CALL_CONTEXT): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
         -- text_event(channel, pitch, text)
      require
         context.argument_count = 1
         context.argument_is_string(1)
      local
         text: STRING
         event: MIXUP_TRANSFORM_VALUE_EVENT
         text_event: MIXUP_MIDI_META_EVENT
         err: ABSTRACT_STRING
         e: MIXUP_MIDI_META_EVENTS
      do
         text := context.argument_string(1)
         text_event := e.text_event(text)
         create event.make
         event.set_value(text_event)
         Result := [event, err]
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
