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
class MIXUP_EVENT_START_PHRASING_SLUR

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
   xuplet_numerator: INTEGER_64
   xuplet_denominator: INTEGER_64
   text: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_START_PHRASING_SLUR_PLAYER
      do
         p ::= player
         p.play_start_phrasing_slur(data, xuplet_numerator, xuplet_denominator, text)
      end

feature {}
   make (a_data: like data; a_xuplet_numerator: INTEGER_64; a_xuplet_denominator: INTEGER_64; a_text: ABSTRACT_STRING) is
      require
         a_text /= Void
      do
         make_(a_data)
         xuplet_numerator := a_xuplet_numerator
         xuplet_denominator := a_xuplet_denominator
         text := a_text.intern
      ensure
         xuplet_numerator = a_xuplet_numerator
         xuplet_denominator = a_xuplet_denominator
         text = a_text
      end

   out_in_extra_data is
      do
         tagged_out_memory.append(once ", div=")
         xuplet_numerator.append_in(tagged_out_memory)
         tagged_out_memory.extend('/')
         xuplet_denominator.append_in(tagged_out_memory)
         if not text.is_empty then
            tagged_out_memory.extend('(')
            text.out_in_tagged_out_memory
            tagged_out_memory.extend(')')
         end
      end

invariant
   text /= Void

end -- class MIXUP_EVENT_START_PHRASING_SLUR
