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
class MIXUP_DYNAMICS

inherit
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   timing: MIXUP_MUSIC_TIMING
   valid_anchor: BOOLEAN is False

   anchor: MIXUP_NOTE_HEAD is do end
   text: FIXED_STRING
   position: FIXED_STRING
   is_standard: BOOLEAN

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      do
         create Result.make(source, text, position, is_standard)
         Result.set_timing(0, a_commit_context.bar_number, 0)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_EVENT_SET_DYNAMICS}.make(a_context.event_data(source), text, position, is_standard))
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "dyn:")
         text.out_in_tagged_out_memory
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   frozen add_voice_ids (ids: AVL_SET[INTEGER])
      do
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER)
      do
         timing := timing.set(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_text, a_position: FIXED_STRING; a_standard: like is_standard)
      require
         a_source /= Void
         a_text /= Void
      do
         source := a_source
         text := a_text
         position := a_position
         is_standard := a_standard
      ensure
         source = a_source
         text = a_text
         position = a_position
         is_standard = a_standard
      end

invariant
   text /= Void

end -- class MIXUP_DYNAMICS
