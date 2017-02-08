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
class MIXUP_EVENT_SKIP_OCTAVE

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
   skip: INTEGER_8

   needs_instrument: BOOLEAN is True

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER)
      local
         p: MIXUP_EVENT_SKIP_OCTAVE_PLAYER
      do
         p ::= player
         p.play_skip_octave(data, skip)
      end

feature {}
   make (a_data: like data; a_skip: like skip)
      do
         make_(a_data)
         skip := a_skip
      ensure
         skip = a_skip
      end

   out_in_extra_data
      do
         tagged_out_memory.append(once ", skip=")
         skip.append_in(tagged_out_memory)
      end

end -- class MIXUP_EVENT_SKIP_OCTAVE
