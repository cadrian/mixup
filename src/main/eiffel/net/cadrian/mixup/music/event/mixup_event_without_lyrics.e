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
deferred class MIXUP_EVENT_WITHOUT_LYRICS

inherit
   MIXUP_EVENT

feature {ANY}
   allow_lyrics: BOOLEAN is False
   has_lyrics: BOOLEAN is False

   set_has_lyrics (enable: BOOLEAN) is
      do
         crash
      end

   set_lyrics (a_lyrics: like lyrics) is
      do
         crash
      end

   lyrics: TRAVERSABLE[MIXUP_SYLLABLE] is
      do
         check Result = Void end
      end

end -- class MIXUP_EVENT_WITHOUT_LYRICS
