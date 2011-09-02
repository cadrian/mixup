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
deferred class MIXUP_EVENT_SKIP_OCTAVE_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_SKIP_OCTAVE}
   play_skip_octave (a_data: MIXUP_EVENT_DATA; a_skip: INTEGER_8) is
      require
         a_data.instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_SKIP_OCTAVE_PLAYER
