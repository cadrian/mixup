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
expanded class MIXUP_MIDI_CONTROLLER_KNOBS

insert
   MIXUP_MIDI_EVENT_TYPES

feature {ANY}
   switch_off: INTEGER_8 is 63
   switch_on:  INTEGER_8 is 64

feature {ANY}
   knobs: MAP[MIXUP_MIDI_CONTROLLER_KNOB, FIXED_STRING]
      local
         dico: HASHED_DICTIONARY[MIXUP_MIDI_CONTROLLER_KNOB, FIXED_STRING]
      once
         create dico.make
         Result := dico

         {FAST_ARRAY[MIXUP_MIDI_CONTROLLER_KNOB]
         <<
           bank_controller,
           modulation_wheel_controller,
           breath_controller,
           foot_controller,
           portamento_time_controller,
           channel_volume_controller,
           balance_controller,
           pan_controller,
           expression_controller,
           effect_1_controller,
           effect_2_controller,
           general_purpose_1_controller,
           general_purpose_2_controller,
           general_purpose_3_controller,
           general_purpose_4_controller,
           damper_pedal_controller,
           portamento_controller,
           sostenuto_controller,
           soft_pedal_controller,
           legato_footswitch_controller,
           fine_bank_controller,
           fine_modulation_wheel_controller,
           fine_breath_controller,
           fine_foot_controller,
           fine_portamento_time_controller,
           fine_channel_volume_controller,
           fine_balance_controller,
           fine_pan_controller,
           fine_expression_controller,
           fine_effect_1_controller,
           fine_effect_2_controller,
           fine_general_purpose_1_controller,
           fine_general_purpose_2_controller,
           fine_general_purpose_3_controller,
           fine_general_purpose_4_controller,
           >> }.do_all(agent (knob: MIXUP_MIDI_CONTROLLER_KNOB; dic: HASHED_DICTIONARY[MIXUP_MIDI_CONTROLLER_KNOB, FIXED_STRING])
                       do
                          dic.add(knob, knob.name)
                       end(?, dico))
      end

feature {ANY} -- coarse controllers (most common)
   bank_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(0, 0, event_program_change, "bank_controller")
      end

   modulation_wheel_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(1, 0, event_controller, "modulation_wheel_controller")
      end

   breath_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(2, 0, event_controller, "breath_controller")
      end

   foot_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(4, 0, event_controller, "foot_controller")
      end

   portamento_time_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(5, 0, event_controller, "portamento_time_controller")
      end

   channel_volume_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(7, 0, event_controller, "channel_volume_controller")
      end

   balance_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(8, 0, event_controller, "balance_controller")
      end

   pan_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(10, 0, event_controller, "pan_controller")
      end

   expression_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(11, 0, event_controller, "expression_controller")
      end

   effect_1_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(12, 0, event_controller, "effect_1_controller")
      end

   effect_2_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(13, 0, event_controller, "effect_2_controller")
      end

   general_purpose_1_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(16, 0, event_controller, "general_purpose_1_controller")
      end

   general_purpose_2_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(17, 0, event_controller, "general_purpose_2_controller")
      end

   general_purpose_3_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(18, 0, event_controller, "general_purpose_3_controller")
      end

   general_purpose_4_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(19, 0, event_controller, "general_purpose_4_controller")
      end

   damper_pedal_controller: MIXUP_MIDI_CONTROLLER_SWITCH
      once
         create Result.make(64, "damper_pedal_controller")
      end

   portamento_controller: MIXUP_MIDI_CONTROLLER_SWITCH
      once
         create Result.make(65, "portamento_controller")
      end

   sostenuto_controller: MIXUP_MIDI_CONTROLLER_SWITCH
      once
         create Result.make(66, "sostenuto_controller")
      end

   soft_pedal_controller: MIXUP_MIDI_CONTROLLER_SWITCH
      once
         create Result.make(67, "soft_pedal_controller")
      end

   legato_footswitch_controller: MIXUP_MIDI_CONTROLLER_SWITCH
      once
         create Result.make(68, "legato_footswitch_controller")
      end

feature {ANY} -- fine controllers (rarer)
   fine_bank_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(0, 32, event_program_change, "fine_bank_controller")
      end

   fine_modulation_wheel_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(1, 33, event_controller, "fine_modulation_wheel_controller")
      end

   fine_breath_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(2, 34, event_controller, "fine_breath_controller")
      end

   fine_foot_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(4, 36, event_controller, "fine_foot_controller")
      end

   fine_portamento_time_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(5, 37, event_controller, "fine_portamento_time_controller")
      end

   fine_channel_volume_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(7, 39, event_controller, "fine_channel_volume_controller")
      end

   fine_balance_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(8, 40, event_controller, "fine_balance_controller")
      end

   fine_pan_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(10, 42, event_controller, "fine_pan_controller")
      end

   fine_expression_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(11, 43, event_controller, "fine_expression_controller")
      end

   fine_effect_1_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(12, 44, event_controller, "fine_effect_1_controller")
      end

   fine_effect_2_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(13, 45, event_controller, "fine_effect_2_controller")
      end

   fine_general_purpose_1_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(16, 48, event_controller, "fine_general_purpose_1_controller")
      end

   fine_general_purpose_2_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(17, 49, event_controller, "fine_general_purpose_2_controller")
      end

   fine_general_purpose_3_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(18, 50, event_controller, "fine_general_purpose_3_controller")
      end

   fine_general_purpose_4_controller: MIXUP_MIDI_CONTROLLER_SLIDER
      once
         create Result.make(19, 51, event_controller, "fine_general_purpose_4_controller")
      end

end -- class MIXUP_MIDI_CONTROLLER_KNOBS
