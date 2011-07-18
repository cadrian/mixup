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
class MIXUP_EVENT_NEXT_BAR

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
   style: FIXED_STRING

   needs_instrument: BOOLEAN is True

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_NEXT_BAR_PLAYER
      do
         p ::= player
         p.play_next_bar(data, style)
      end

feature {}
   make (a_data: like data; a_style: ABSTRACT_STRING) is
      do
         make_(a_data)
         if a_style /= Void then
            style := a_style.intern
         end
      ensure
         a_style /= Void implies style = a_style.intern
         a_style = Void implies style = Void
      end

   out_in_extra_data is
      do
         tagged_out_memory.append(once ", style=")
         if style = Void then
            tagged_out_memory.append(once "<default>")
         else
            style.out_in_tagged_out_memory
         end
      end

end -- class MIXUP_EVENT_NEXT_BAR
