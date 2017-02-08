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
class MIXUP_EVENT_END_SCORE

inherit
   MIXUP_EVENT_WITHOUT_LYRICS

create {ANY}
   make

feature {ANY}
   time: INTEGER_64

   out_in_tagged_out_memory
      do
         tagged_out_memory.extend('[')
         tagged_out_memory.append(generating_type)
         tagged_out_memory.append(once ": time=")
         time.append_in(tagged_out_memory)
         tagged_out_memory.extend(']')
      end

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER)
      local
         p: MIXUP_EVENT_END_SCORE_PLAYER
      do
         p ::= player
         p.play_end_score
      end

feature {}
   make (a_source: like source; a_time: like time)
      require
         a_source /= Void
      do
         source := a_source
         time := a_time
      ensure
         source /= Void
         time = a_time
      end

end -- class MIXUP_EVENT_END_SCORE
