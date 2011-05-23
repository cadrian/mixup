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
class MIXUP_ZERO_MUSIC

inherit
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   valid_anchor: BOOLEAN is False

   duration: INTEGER_64 is 0
   anchor: MIXUP_NOTE_HEAD is do end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      do
         Result := start_bar_number
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_ZERO_EVENTS_ITERATOR} Result.make
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "zero")
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   frozen consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

   frozen add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
      end

feature {}
   make (a_source: like source) is
      require
         a_source /= Void
      do
         source := a_source
      ensure
         source = a_source
      end

end -- class MIXUP_ZERO_MUSIC
