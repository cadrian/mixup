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

   accept (visitor: VISITOR) is
      do
         (create {MIXUP_MUSIC_VALUE}.make(source, Current)).accept(visitor)
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like Current is
      do
         Result := twin
         Result.set_timing(0, a_start_bar_number, 0)
      end

feature {ANY}
   valid_anchor: BOOLEAN is False

   anchor: MIXUP_NOTE_HEAD is
      do
         crash
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   add_voice_ids (a_ids: AVL_SET[INTEGER]) is
      do
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         timing := timing.set(a_duration, a_first_bar_number, a_bars_count)
      end

end -- class MIXUP_MIDI_MUSIC_EVENTS_FACTORY
