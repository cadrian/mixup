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
deferred class MIXUP_MIDI_MUSIC_EVENTS_FACTORY

inherit
   MIXUP_VALUE
      undefine
         out_in_tagged_out_memory
      end
   MIXUP_MUSIC
      undefine
         out_in_tagged_out_memory
      end

feature {ANY}
   timing: MIXUP_MUSIC_TIMING
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR)
      do
         (create {MIXUP_MUSIC_VALUE}.make(source, Current)).accept(visitor)
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      do
         Result := twin
         Result.set_timing(0, a_commit_context.bar_number, 0)
      end

feature {ANY}
   valid_anchor: BOOLEAN is False

   anchor: MIXUP_NOTE_HEAD
      do
         crash
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   add_voice_ids (a_ids: AVL_SET[INTEGER])
      do
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER)
      do
         timing := timing.set(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      do
         Result := Current
      end

end -- class MIXUP_MIDI_MUSIC_EVENTS_FACTORY
