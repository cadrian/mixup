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
class MIXUP_SEED_PLAYER

inherit
   MIXUP_PLAYER

create {ANY}
   make

feature {ANY}
   native (a_source: MIXUP_SOURCE; name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         inspect
            name
         when "playback_midi" then
            mixer.add_player(create {MIXUP_MIDI_PLAYER}.make)
         when "playback_lilypond" then
            mixer.add_player(create {MIXUP_LILYPOND_PLAYER}.make)
         else
         end
      end

feature {}
   make (a_mixer: like mixer) is
      require
         a_mixer /= Void
      do
         mixer := a_mixer
      ensure
         mixer = a_mixer
      end

   mixer: MIXUP_MIXER_IMPL

invariant
   mixer /= Void

end -- class MIXUP_DUMMY_PLAYER
