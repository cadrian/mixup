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
   MIXUP_EVENT_WITHOUT_LYRICS

create {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument: FIXED_STRING
   staff_id: INTEGER
   xuplet_numerator: INTEGER_64
   xuplet_denominator: INTEGER_64
   text: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_START_PHRASING_SLUR_PLAYER
      do
         p ::= player
         p.play_start_phrasing_slur(instrument, staff_id, xuplet_numerator, xuplet_denominator, text)
      end

feature {}
   make (a_source: like source; a_time: like time; a_instrument: ABSTRACT_STRING; a_staff_id: like staff_id; a_xuplet_numerator: INTEGER_64; a_xuplet_denominator: INTEGER_64; a_text: ABSTRACT_STRING) is
      require
         a_source /= Void
         a_instrument /= Void
         a_text /= Void
      do
         source := a_source
         time := a_time
         instrument := a_instrument.intern
         staff_id := a_staff_id
         xuplet_numerator := a_xuplet_numerator
         xuplet_denominator := a_xuplet_denominator
         text := a_text.intern
      ensure
         source = a_source
         time = a_time
         instrument = a_instrument.intern
         staff_id = a_staff_id
         xuplet_numerator = a_xuplet_numerator
         xuplet_denominator = a_xuplet_denominator
         text = a_text
      end

invariant
   instrument /= Void
   text /= Void

end -- class MIXUP_EVENT_START_PHRASING_SLUR
