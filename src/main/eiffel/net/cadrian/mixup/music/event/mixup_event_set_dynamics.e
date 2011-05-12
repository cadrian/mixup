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
class MIXUP_EVENT_SET_DYNAMICS

inherit
   MIXUP_EVENT_WITH_DATA
      rename
         make as make_
      redefine
         out_in_extra_data
      end
   MIXUP_EVENT_WITHOUT_LYRICS

create {ANY}
   make

feature {ANY}
   dynamics: FIXED_STRING
   position: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_DYNAMICS_PLAYER
      do
         p ::= player
         p.play_set_dynamics(data, dynamics, position)
      end

feature {}
   make (a_data: like data; a_dynamics: ABSTRACT_STRING; a_position: ABSTRACT_STRING) is
      require
         a_dynamics /= Void
      do
         make_(a_data)
         dynamics := a_dynamics.intern
         if a_position /= Void then
            position := a_position.intern
         end
      ensure
         dynamics = a_dynamics
         a_position /= Void implies position = a_position.intern
         a_position = Void implies position = Void
      end

   out_in_extra_data is
      do
         tagged_out_memory.append(once ", dynamics=")
         dynamics.out_in_tagged_out_memory
         if position /= Void then
            tagged_out_memory.append(once ", position=")
            position.out_in_tagged_out_memory
         end
      end

invariant
   dynamics /= Void

end -- class MIXUP_EVENT_SET_DYNAMICS
