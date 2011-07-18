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
class MIXUP_EVENT_START_REPEAT

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
   volte: INTEGER_64

   needs_instrument: BOOLEAN is True

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_START_REPEAT_PLAYER
      do
         p ::= player
         p.play_start_repeat(data, volte)
      end

feature {}
   make (a_data: like data; a_volte: INTEGER_64) is
      do
         make_(a_data)
         volte := a_volte
      ensure
         volte = a_volte
      end

   out_in_extra_data is
      do
         tagged_out_memory.append(once ", volte=")
         volte.append_in(tagged_out_memory)
      end

end -- class MIXUP_EVENT_START_REPEAT
