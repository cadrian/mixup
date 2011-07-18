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
class MIXUP_EVENT_SET_NOTE

inherit
   MIXUP_EVENT_WITH_DATA
      rename
         make as make_
      redefine
         out_in_extra_data
      end

create {ANY}
   make

feature {ANY}
   note: MIXUP_NOTE

   allow_lyrics: BOOLEAN is
      do
         Result := note.can_have_lyrics
      end

   has_lyrics: BOOLEAN

   set_has_lyrics (enable: BOOLEAN) is
      do
         has_lyrics := enable
      end

   set_lyrics (a_lyrics: like lyrics) is
      do
         lyrics := a_lyrics
      end

   lyrics: TRAVERSABLE[MIXUP_SYLLABLE]

   needs_instrument: BOOLEAN is True

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_NOTE_PLAYER
         n: like note
      do
         p ::= player
         n := note
         if lyrics /= Void then
            create {MIXUP_LYRICS} n.make(source, note, lyrics) -- TODO: wrong source! should keep the actual one along with the lyrics.
         end
         p.play_set_note(data, n)
      end

feature {}
   make (a_data:like data; a_note: MIXUP_NOTE) is
      require
         a_note /= Void
      do
         make_(a_data)
         note := a_note
         if allow_lyrics then
            set_has_lyrics(True)
         end
      ensure
         note = a_note
      end

   out_in_extra_data is
      do
         tagged_out_memory.append(once ", note=")
         note.out_in_tagged_out_memory
      end

invariant
   note /= Void

end -- class MIXUP_EVENT_SET_NOTE
