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
class MIXUP_LILYPOND_HEADER_EVENT

inherit
   MIXUP_EVENT_WITH_DATA
      rename
         make as make_
      redefine
         out_in_extra_data
      end
   MIXUP_EVENT_WITHOUT_LYRICS

create {MIXUP_LILYPOND_HEADER_EVENT_FACTORY}
   make

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_LILYPOND_PLAYER
      do
         p ::= player
         p.play_header_event(data, string)
      end

feature {}
   make (a_data: like data; a_string: like string) is
      require
         a_string /= Void
      do
         make_(a_data)
         string := a_string
      ensure
         string = a_string
      end

   out_in_extra_data is
      do
         tagged_out_memory.append(once ", string=")
         string.out_in_tagged_out_memory
      end

   string: FIXED_STRING

invariant
   string /= Void

end -- class MIXUP_LILYPOND_HEADER_EVENT
