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
class MIXUP_EVENT_START_VOICES

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
   voices: TRAVERSABLE[INTEGER]

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_START_VOICES_PLAYER
      do
         p ::= player
         p.play_start_voices(data, voices)
      end

feature {}
   make (a_data: like data; a_voices: like voices) is
      require
         a_voices /= Void
      do
         make_(a_data)
         voices := a_voices
      ensure
         voices = a_voices
      end

   out_in_extra_data is
      do
         tagged_out_memory.append(once ", voices=")
         voices.out_in_tagged_out_memory
      end

invariant
   voices /= Void

end -- class MIXUP_EVENT_START_VOICES
