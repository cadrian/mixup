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
   MIXUP_EVENT_WITHOUT_LYRICS

create {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument: FIXED_STRING
   volte: INTEGER_64

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_START_REPEAT_PLAYER
      do
         p ::= player
         p.play_start_repeat(instrument, volte)
      end

feature {}
   make (a_source: like source; a_time: like time; a_instrument: ABSTRACT_STRING; a_volte: INTEGER_64) is
      require
         a_source /= Void
         a_instrument /= Void
      do
         source := a_source
         time := a_time
         instrument := a_instrument.intern
         volte := a_volte
      ensure
         source = a_source
         time = a_time
         instrument = a_instrument
         volte = a_volte
      end

invariant
   instrument /= Void

end -- class MIXUP_EVENT_START_REPEAT
