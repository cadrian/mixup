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
   timing: MIXUP_MUSIC_TIMING is
      deferred
      end

   duration: INTEGER_64 is
      do
         Result := timing.duration
      end

   valid_anchor: BOOLEAN is
      deferred
      end

   anchor: MIXUP_NOTE_HEAD is
      require
         valid_anchor
      deferred
      ensure
         not Result.is_rest
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current is
      deferred
      ensure
         Result /= Void
         Result /= Current
         Result.timing.is_set
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      deferred
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   add_voice_ids (a_ids: AVL_SET[INTEGER]) is
      require
         a_ids /= Void
      deferred
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      deferred
      ensure
         timing.is_set
         timing.duration = a_duration
         timing.first_bar_number = a_first_bar_number
         timing.bars_count = a_bars_count
      end

invariant
   source /= Void

end -- class MIXUP_MUSIC
