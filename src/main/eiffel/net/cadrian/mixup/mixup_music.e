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
deferred class MIXUP_MUSIC

insert
   MIXUP_ERRORS

feature {ANY}
   duration: INTEGER_64 is
      deferred
      end

   valid_anchor: BOOLEAN is
      deferred
      end

   anchor: MIXUP_NOTE_HEAD is
      require
         valid_anchor
      deferred
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      deferred
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      deferred
      end

   set_staff_id (a_staff_id: like staff_id) is
      do
         staff_id := a_staff_id
      ensure
         staff_id = a_staff_id
      end

   staff_id: INTEGER

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      require
         bars /= Void
      deferred
      end

invariant
   source /= Void

end -- class MIXUP_MUSIC
