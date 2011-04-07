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
deferred class MIXUP_COMPOUND_MUSIC

inherit
   MIXUP_MUSIC

feature {ANY}
   valid_anchor: BOOLEAN is True

   add_music (a_music: MIXUP_MUSIC) is
      deferred
      end

   add_chord (a_source: like source; note_heads: COLLECTION[FIXED_STRING]; note_length: INTEGER_64) is
      deferred
      end

   reference: MIXUP_NOTE_HEAD is
      deferred
      end

   add_bar (a_source: like source; style: FIXED_STRING) is
      deferred
      end

   bars: ITERABLE[INTEGER_64] is
      deferred
      end

   up_staff is
      deferred
      end

   down_staff is
      deferred
      end

end -- class MIXUP_COMPOUND_MUSIC
