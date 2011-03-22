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
deferred class MIXUP_PLAYER
-- just a VISITOR with a fancy name (viz. an Acyclic Visitor)
--
-- see also MIXUP_CORE_PLAYER

feature {ANY}
   play (a_event: MIXUP_EVENT) is
      require
         a_event /= Void
      do
         a_event.fire(Current)
      end

end -- class MIXUP_PLAYER
