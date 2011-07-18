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
class MIXUP_MIDI_MPC_END

inherit
   MIXUP_EVENT_WITH_DATA
      rename
         make as make_
      redefine
         out_in_extra_data
      end
   MIXUP_EVENT_WITHOUT_LYRICS

create {MIXUP_MIDI_MPC_END_FACTORY}
   make

feature {ANY}
   knob: MIXUP_MIDI_CONTROLLER_KNOB
   start: MIXUP_MIDI_MPC_START
   start_value, end_value: INTEGER_8

   needs_instrument: BOOLEAN is True

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_MIDI_PLAYER
      do
         p ::= player
         p.play_mpc(data, knob, start.time, start_value, end_value)
      end

feature {}
   make (a_data: like data; a_start: like start; a_knob: like knob; a_start_value: like start_value; a_end_value: like end_value) is
      require
         a_start /= Void
         a_knob /= Void
         a_start_value >= 0
         a_end_value >= 0
      do
         start := a_start
         knob := a_knob
         start_value := a_start_value
         end_value := a_end_value
         make_(a_data)
      ensure
         start = a_start
         knob = a_knob
         start_value = a_start_value
         end_value = a_end_value
      end

   out_in_extra_data is
      do
         -- TODO
      end

invariant
   start /= Void
   knob /= Void
   start_value >= 0
   end_value >= 0

end -- class MIXUP_MIDI_MPC_END
