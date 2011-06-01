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
   name: FIXED_STRING is
      once
         Result := "seed".intern
      end

   set_context (a_context: MIXUP_CONTEXT) is
      do
      end

   native (a_source: MIXUP_SOURCE; fn_name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         inspect
            fn_name
         when "playback_midi" then
            native_playback_midi
         when "playback_lilypond" then
            native_playback_lilypond
         else
         end
      end

feature {}
   native_playback_midi is
      once
         mixer.add_player(create {MIXUP_MIDI_PLAYER}.make)
      end

   native_playback_lilypond is
      once
         mixer.add_player(create {MIXUP_LILYPOND_PLAYER}.make)
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

   mixer: MIXUP_MIXER

invariant
   mixer /= Void

end -- class MIXUP_DUMMY_PLAYER
