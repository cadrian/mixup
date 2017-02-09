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
deferred class MIXUP_MIDI_CODEC_VISITOR

feature {MIXUP_MIDI_KEY_PRESSURE}
   visit_mixup_midi_key_pressure (codec: MIXUP_MIDI_KEY_PRESSURE)
      require
         codec /= Void
      deferred
      end

feature {MIXUP_MIDI_CHANNEL_PRESSURE}
   visit_mixup_midi_channel_pressure (codec: MIXUP_MIDI_CHANNEL_PRESSURE)
      require
         codec /= Void
      deferred
      end

feature {MIXUP_MIDI_PITCH_BEND}
   visit_mixup_midi_pitch_bend (codec: MIXUP_MIDI_PITCH_BEND)
      require
         codec /= Void
      deferred
      end

feature {MIXUP_MIDI_CONTROLLER_SLIDER}
   visit_mixup_midi_controller_slider (codec: MIXUP_MIDI_CONTROLLER; knob: MIXUP_MIDI_CONTROLLER_SLIDER)
      require
         codec /= Void
         codec.knob = knob
      deferred
      end

feature {MIXUP_MIDI_CONTROLLER_SWITCH}
   visit_mixup_midi_controller_switch (codec: MIXUP_MIDI_CONTROLLER; knob: MIXUP_MIDI_CONTROLLER_SWITCH)
      require
         codec /= Void
         codec.knob = knob
      deferred
      end

feature {MIXUP_MIDI_NOTE_ON}
   visit_mixup_midi_note_on (codec: MIXUP_MIDI_NOTE_ON)
      require
         codec /= Void
      deferred
      end

feature {MIXUP_MIDI_NOTE_OFF}
   visit_mixup_midi_note_off (codec: MIXUP_MIDI_NOTE_OFF)
      require
         codec /= Void
      deferred
      end

feature {MIXUP_MIDI_PROGRAM_CHANGE}
   visit_mixup_midi_program_change (codec: MIXUP_MIDI_PROGRAM_CHANGE)
      require
         codec /= Void
      deferred
      end

feature {MIXUP_MIDI_META_EVENT}
   visit_mixup_midi_meta_event (codec: MIXUP_MIDI_META_EVENT)
      require
         codec /= Void
      deferred
      end

end -- class MIXUP_MIDI_CODEC_VISITOR
