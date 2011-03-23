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
deferred class MIXUP_NOTE_VISITOR

inherit
   VISITOR

feature {MIXUP_CHORD}
   visit_chord (a_chord: MIXUP_CHORD) is
      require
         a_chord /= Void
      deferred
      end

feature {MIXUP_LYRICS}
   visit_lyrics (a_lyrics: MIXUP_LYRICS) is
      require
         a_lyrics /= Void
      deferred
      end

end -- class MIXUP_NOTE_VISITOR
