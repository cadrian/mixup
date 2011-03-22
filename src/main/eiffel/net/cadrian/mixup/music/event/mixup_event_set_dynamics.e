-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_EVENT_SET_DYNAMICS

inherit
   MIXUP_EVENT_WITHOUT_LYRICS

create {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument_name: FIXED_STRING
   dynamics: FIXED_STRING
   position: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_DYNAMICS_PLAYER
      do
         p ::= player
         p.play_set_dynamics(instrument_name, dynamics, position)
      end

feature {}
   make (a_time: like time; a_instrument_name: ABSTRACT_STRING; a_dynamics: ABSTRACT_STRING; a_position: ABSTRACT_STRING) is
      require
         a_instrument_name /= Void
         a_dynamics /= Void
      do
         time := a_time
         instrument_name := a_instrument_name.intern
         dynamics := a_dynamics.intern
         if a_position /= Void then
            position := a_position.intern
         end
      ensure
         time = a_time
         instrument_name = a_instrument_name
         dynamics = a_dynamics
         position = a_position
      end

invariant
   instrument_name /= Void
   dynamics /= Void

end -- class MIXUP_EVENT_SET_DYNAMICS
