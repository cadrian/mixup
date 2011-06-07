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

feature {ANY}
   switch_off: INTEGER_8 is 63
   switch_on:  INTEGER_8 is 64

   bank_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(0, 32)
      end

   modulation_wheel_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(1, 33)
      end

   breath_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(2, 34)
      end

   foot_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(4, 36)
      end

   portamento_time_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(5, 37)
      end

   channel_volume_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(7, 39)
      end

   balance_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(8, 40)
      end

   pan_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(10, 42)
      end

   expression_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(11, 43)
      end

   effect_1_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(12, 44)
      end

   effect_2_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(13, 45)
      end

   general_porpose_1_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(16, 48)
      end

   general_porpose_2_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(17, 49)
      end

   general_porpose_3_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(18, 50)
      end

   general_porpose_4_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SLIDER} Result.make(19, 51)
      end

   damper_pedal_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SWITCH} Result.make(64)
      end

   portamento_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SWITCH} Result.make(65)
      end

   sostenuto_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SWITCH} Result.make(66)
      end

   soft_pedal_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SWITCH} Result.make(67)
      end

   legato_footswitch_controller: MIXUP_MIDI_CONTROLLER_KNOB is
      once
         create {MIXUP_MIDI_CONTROLLER_SWITCH} Result.make(68)
      end

end -- class MIXUP_MIDI_CONTROLLER_KNOBS
