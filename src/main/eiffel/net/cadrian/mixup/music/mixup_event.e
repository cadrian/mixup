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
deferred class MIXUP_EVENT
   -- Just a VISITABLE with a fancy name
   --
   -- See also MIXUP_PLAYER

inherit
   COMPARABLE
      undefine out_in_tagged_out_memory
      end

insert
   MIXUP_ERRORS
      undefine is_equal, out_in_tagged_out_memory
      end

feature {ANY}
   infix "<" (other: MIXUP_EVENT): BOOLEAN
      do
         Result := time < other.time
      end

   time: INTEGER_64
      deferred
      end

   allow_lyrics: BOOLEAN
      deferred
      end

   has_lyrics: BOOLEAN
      deferred
      ensure
         not allow_lyrics implies not Result
      end

   set_has_lyrics (enable: BOOLEAN)
      require
         allow_lyrics
         lyrics = Void
      deferred
      ensure
         has_lyrics = enable
      end

   set_lyrics (a_lyrics: like lyrics)
      require
         has_lyrics
         a_lyrics /= Void
         lyrics = Void
      deferred
      ensure
         lyrics = a_lyrics
      end

   lyrics: TRAVERSABLE[MIXUP_SYLLABLE]
      require
         allow_lyrics
      deferred
      end

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER)
      require
         player /= Void
      deferred
      end

invariant
   source /= Void

end -- class MIXUP_EVENT
