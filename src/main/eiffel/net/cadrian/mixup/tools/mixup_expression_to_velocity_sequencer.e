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
class MIXUP_EXPRESSION_TO_VELOCITY_SEQUENCER

inherit
   MIXUP_MIDI_CODEC_VISITOR

insert
   LOGGING
   MIXUP_MIDI_META_EVENTS

create {MIXUP_EXPRESSION_TO_VELOCITY}
   make

feature {MIXUP_EXPRESSION_TO_VELOCITY}
   start
      do
         sequencer.start
         advance
      end

   next
      do
         sequencer.next
         advance
      end

   track_index: INTEGER
      require
         not is_off
      do
         Result := sequencer.track_index
      end

   time: INTEGER_64
      require
         not is_off
      do
         Result := sequencer.time
      end

   event: MIXUP_MIDI_CODEC
      require
         not is_off
      attribute
      end

   is_off: BOOLEAN
      do
         Result := sequencer.is_off
      end

feature {}
   advance
      local
         e: MIXUP_MIDI_CODEC
      do
         from
            event := Void
         until
            event /= Void or else is_off
         loop
            e := sequencer.event
            e.accept(Current)
            if event = Void then
               sequencer.next
            end
         end
      ensure
         (not is_off) implies event /= Void
      end

feature {MIXUP_MIDI_KEY_PRESSURE}
   visit_mixup_midi_key_pressure (codec: MIXUP_MIDI_KEY_PRESSURE)
      do
         event := codec
      end

feature {MIXUP_MIDI_CHANNEL_PRESSURE}
   visit_mixup_midi_channel_pressure (codec: MIXUP_MIDI_CHANNEL_PRESSURE)
      do
         event := codec
      end

feature {MIXUP_MIDI_PITCH_BEND}
   visit_mixup_midi_pitch_bend (codec: MIXUP_MIDI_PITCH_BEND)
      do
         event := codec
      end

feature {MIXUP_MIDI_CONTROLLER_SLIDER}
   visit_mixup_midi_controller_slider (codec: MIXUP_MIDI_CONTROLLER; knob: MIXUP_MIDI_CONTROLLER_SLIDER)
      local
         value: INTEGER
      do
         if knob.msb_code = 11 then
            value := codec.value
            if knob.lsb_code = 43 then
               value := value |>>> 7 -- no need for the "fine" part
            else
               check
                  knob.lsb_code = 0
               end
            end
            check
               value.in_range(0, 127)
            end
            expression.put(value, codec.channel)
            log.info.put_line("Track #(1) channel #(2) expression=#(3)" # track_index.out # codec.channel.out # value.out)
            check
               need_more_events: event = Void
            end
         else
            event := codec
            log.info.put_line("Track #(1) channel #(2) controller=#(3)" # track_index.out # codec.channel.out # knob.name)
         end
      end

feature {MIXUP_MIDI_CONTROLLER_SWITCH}
   visit_mixup_midi_controller_switch (codec: MIXUP_MIDI_CONTROLLER; knob: MIXUP_MIDI_CONTROLLER_SWITCH)
      do
         event := codec
      end

feature {MIXUP_MIDI_NOTE_ON}
   visit_mixup_midi_note_on (codec: MIXUP_MIDI_NOTE_ON)
      local
         velocity: INTEGER_32
      do
         velocity := codec.velocity * expression.item(codec.channel) // 127
         create {MIXUP_MIDI_NOTE_ON} event.make(codec.channel, codec.pitch, velocity)
      end

feature {MIXUP_MIDI_NOTE_OFF}
   visit_mixup_midi_note_off (codec: MIXUP_MIDI_NOTE_OFF)
      local
         velocity: INTEGER_32
      do
         velocity := codec.velocity * expression.item(codec.channel) // 127
         create {MIXUP_MIDI_NOTE_OFF} event.make(codec.channel, codec.pitch, velocity)
      end

feature {MIXUP_MIDI_PROGRAM_CHANGE}
   visit_mixup_midi_program_change (codec: MIXUP_MIDI_PROGRAM_CHANGE)
      do
         event := codec
      end

feature {MIXUP_MIDI_META_EVENT}
   visit_mixup_midi_meta_event (codec: MIXUP_MIDI_META_EVENT)
      do
         event := codec
         log.info.put_line("Track #(1) meta-event=#(2)" # track_index.out # codec.name)
      end

feature {}
   make (a_input: MIXUP_MIDI_FILE)
      require
         a_input /= Void
      do
         create sequencer.make(a_input)
         create {FAST_ARRAY[INTEGER]} expression.make(16)
         expression.set_all_with(127)
      end

   sequencer: MIXUP_MIDI_FILE_SEQUENCER
         -- the input MIDI sequencer

   expression: COLLECTION[INTEGER]
         -- expression per channel

invariant
   sequencer /= Void
   expression.count = 16
   expression.for_all(agent (exp: INTEGER): BOOLEAN then exp.in_range(0, 127) end (?))

end -- class MIXUP_EXPRESSION_TO_VELOCITY_SEQUENCER
