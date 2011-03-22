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
class MIXUP_GROUPED_MUSIC_LYRICS_MANAGER

create {MIXUP_GROUPED_MUSIC}
   make

feature {MIXUP_GROUPED_MUSIC}
   manage_lyrics (context: MIXUP_EVENTS_ITERATOR_CONTEXT; event: MIXUP_EVENT): MIXUP_EVENT is
      do
         Result := event
         if Result.allow_lyrics then
            Result.set_has_lyrics(has_lyrics)
            has_lyrics := allow_lyrics
         end
      end

feature {}
   make (a_allow_lyrics: like allow_lyrics) is
      do
         allow_lyrics := a_allow_lyrics
         has_lyrics := True
      ensure
         allow_lyrics = a_allow_lyrics
      end

   allow_lyrics: BOOLEAN
   has_lyrics: BOOLEAN

end -- class MIXUP_GROUPED_MUSIC_LYRICS_MANAGER
