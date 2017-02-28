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
class MIXUP_TRANSFORM_EVENT_FIELD_GETTER

inherit
   MIXUP_MIDI_CODEC_VISITOR

create {MIXUP_TRANSFORM_TYPE_EVENT}
   make

feature {MIXUP_TRANSFORM_TYPE_EVENT}
   item (a_event: MIXUP_MIDI_CODEC; a_field: STRING): MIXUP_TRANSFORM_VALUE
      require
         not is_busy
         a_event /= Void
         a_field /= Void
      do
         field := a_field
         check is_busy end
         a_event.accept(Current)
         field := Void
         Result := res
         res := Void
      ensure
         not is_busy
      end

   is_busy: BOOLEAN then field /= Void end

feature {}
   field: STRING
   res: MIXUP_TRANSFORM_VALUE

   set_res_numeric (value: INTEGER)
      local
         r: MIXUP_TRANSFORM_VALUE_NUMERIC
      do
         create r.make
         r.set_value(value)
         res := r
      end

   set_res_boolean (value: BOOLEAN)
      local
         r: MIXUP_TRANSFORM_VALUE_BOOLEAN
      do
         create r.make
         r.set_value(value)
         res := r
      end

   set_res_string (value: ABSTRACT_STRING)
      require
         value /= Void
      local
         r: MIXUP_TRANSFORM_VALUE_STRING
      do
         create r.make
         r.set_value(value.out)
         res := r
      end

feature {MIXUP_MIDI_KEY_PRESSURE}
   visit_mixup_midi_key_pressure (codec: MIXUP_MIDI_KEY_PRESSURE)
      do
         inspect field
         when "velocity" then
         when "channel" then
            set_res_numeric(codec.channel)
         when "pitch" then
            set_res_numeric(codec.key)
         when "meta" then
         when "value" then
            set_res_numeric(codec.pressure)
         when "fine" then
         when "type" then
            set_res_string("key pressure")
         end
      end

feature {MIXUP_MIDI_CHANNEL_PRESSURE}
   visit_mixup_midi_channel_pressure (codec: MIXUP_MIDI_CHANNEL_PRESSURE)
      do
         inspect field
         when "velocity" then
         when "channel" then
            set_res_numeric(codec.channel)
         when "pitch" then
         when "meta" then
         when "value" then
            set_res_numeric(codec.pressure)
         when "fine" then
         when "type" then
            set_res_string("channel pressure")
         end
      end

feature {MIXUP_MIDI_PITCH_BEND}
   visit_mixup_midi_pitch_bend (codec: MIXUP_MIDI_PITCH_BEND)
      do
         inspect field
         when "velocity" then
         when "channel" then
            set_res_numeric(codec.channel)
         when "pitch" then
            set_res_numeric(codec.pitch)
         when "meta" then
         when "value" then
            set_res_numeric(codec.pitch)
         when "fine" then
         when "type" then
            set_res_string("pitch bend")
         end
      end

feature {MIXUP_MIDI_CONTROLLER_SLIDER}
   visit_mixup_midi_controller_slider (codec: MIXUP_MIDI_CONTROLLER; knob: MIXUP_MIDI_CONTROLLER_SLIDER)
      do
         inspect field
         when "velocity" then
         when "channel" then
            set_res_numeric(codec.channel)
         when "pitch" then
         when "meta" then
            set_res_numeric(knob.msb_code)
         when "value" then
            set_res_numeric(codec.value)
         when "fine" then
            set_res_boolean(knob.is_fine)
         when "type" then
            set_res_string("controller")
         end
      end

feature {MIXUP_MIDI_CONTROLLER_SWITCH}
   visit_mixup_midi_controller_switch (codec: MIXUP_MIDI_CONTROLLER; knob: MIXUP_MIDI_CONTROLLER_SWITCH)
      do
         inspect field
         when "velocity" then
         when "channel" then
            set_res_numeric(codec.channel)
         when "pitch" then
         when "meta" then
            set_res_numeric(knob.code)
         when "value" then
            set_res_numeric(codec.value)
         when "fine" then
         when "type" then
            set_res_string("controller")
         end
      end

feature {MIXUP_MIDI_NOTE_ON}
   visit_mixup_midi_note_on (codec: MIXUP_MIDI_NOTE_ON)
      do
         inspect field
         when "velocity" then
            set_res_numeric(codec.velocity)
         when "channel" then
            set_res_numeric(codec.channel)
         when "pitch" then
            set_res_numeric(codec.pitch)
         when "meta" then
         when "value" then
         when "fine" then
         when "type" then
            set_res_string("note on")
         end
      end

feature {MIXUP_MIDI_NOTE_OFF}
   visit_mixup_midi_note_off (codec: MIXUP_MIDI_NOTE_OFF)
      do
         inspect field
         when "velocity" then
            set_res_numeric(codec.velocity)
         when "channel" then
            set_res_numeric(codec.channel)
         when "pitch" then
            set_res_numeric(codec.pitch)
         when "meta" then
         when "value" then
         when "fine" then
         when "type" then
            set_res_string("note off")
         end
      end

feature {MIXUP_MIDI_PROGRAM_CHANGE}
   visit_mixup_midi_program_change (codec: MIXUP_MIDI_PROGRAM_CHANGE)
      do
         inspect field
         when "velocity" then
         when "channel" then
         when "pitch" then
         when "meta" then
         when "value" then
            set_res_numeric(codec.patch)
         when "fine" then
         when "type" then
            set_res_string("program change")
         end
      end

feature {MIXUP_MIDI_META_EVENT}
   visit_mixup_midi_meta_event (codec: MIXUP_MIDI_META_EVENT)
      do
         inspect field
         when "velocity" then
         when "channel" then
         when "pitch" then
         when "meta" then
         when "value" then
            set_res_string(codec.data)
         when "fine" then
         when "type" then
            set_res_string(codec.name)
         end
      end

feature {}
   make
      do
      end

end -- class MIXUP_TRANSFORM_EVENT_FIELD_GETTER
