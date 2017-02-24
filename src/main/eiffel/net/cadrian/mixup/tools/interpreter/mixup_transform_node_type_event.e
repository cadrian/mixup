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
class MIXUP_TRANSFORM_NODE_TYPE_EVENT

inherit
   MIXUP_TRANSFORM_NODE_TYPE_IMPL[MIXUP_MIDI_CODEC]

insert
   LOGGING
      undefine
         is_equal
      end
   MIXUP_TRANSFORM_NODE_TYPES
      undefine
         is_equal
      end

create {MIXUP_TRANSFORM_NODE_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN False

   -- field_type (field_name: STRING): MIXUP_TRANSFORM_NODE_TYPE
   --    do
   --       inspect field_name
   --       when "velocity", "channel", "meta", "pitch", "time" then
   --          Result := type_numeric
   --       when "fine" then
   --          Result := type_boolean
   --       else
   --       end
   --    end

   ref: REFERENCE[MIXUP_MIDI_CODEC]

   set_event (a_event: MIXUP_MIDI_CODEC)
      do
         ref.set_item(a_event)
      ensure
         event = a_event
      end

   event: MIXUP_MIDI_CODEC then ref.item
      end

feature {MIXUP_TRANSFORM_NODE_TYPES}
   init
      do
         create ref
      end

end -- class MIXUP_TRANSFORM_NODE_TYPE_EVENT
