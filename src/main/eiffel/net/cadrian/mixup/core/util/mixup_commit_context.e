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
expanded class MIXUP_COMMIT_CONTEXT

insert
   ANY
      redefine
         default_create
      end

feature {ANY}
   bar_number: INTEGER

   context: MIXUP_CONTEXT
   player: MIXUP_PLAYER

   instrument: MIXUP_INSTRUMENT
   staff: MIXUP_STAFF
   voice: MIXUP_VOICE

feature {ANY}
   reset
      do
         bar_number := 0
         context := Void
         player := Void
         instrument := Void
         staff := Void
         voice := Void
      end

feature {}
   default_create
      do
         reset
      end

feature {ANY}
   set_bar_number (a_bar_number: like bar_number)
      do
         bar_number := a_bar_number
      ensure
         bar_number = a_bar_number
      end

   set_player (a_player: like player)
      require
         a_player /= Void
      do
         player := a_player
      ensure
         player = a_player
      end

feature {MIXUP_CONTEXT}
   set_context (a_context: like context)
      require
         a_context /= Void
      do
         context := a_context
      ensure
         context = a_context
      end

feature {MIXUP_INSTRUMENT}
   set_instrument (a_instrument: like instrument)
      require
         a_instrument /= Void
      do
         instrument := a_instrument
         context := a_instrument
      ensure
         instrument = a_instrument
         context = a_instrument
      end

feature {MIXUP_STAFF}
   set_staff (a_staff: like staff)
      require
         a_staff /= Void
      do
         staff := a_staff
      ensure
         staff = a_staff
      end

feature {MIXUP_VOICE}
   set_voice (a_voice: like voice)
      require
         a_voice /= Void
      do
         voice := a_voice
      ensure
         voice = a_voice
      end

end -- class MIXUP_COMMIT_CONTEXT
