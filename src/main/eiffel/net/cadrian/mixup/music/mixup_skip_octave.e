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
class MIXUP_SKIP_OCTAVE

inherit
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   timing: MIXUP_MUSIC_TIMING
   skip: INTEGER_8

   valid_anchor: BOOLEAN is True

   anchor: MIXUP_NOTE_HEAD

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      do
         create Result.make(source, skip)
         Result.set_timing(0, a_commit_context.bar_number, 0)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_EVENT_SKIP_OCTAVE}.make(a_context.event_data(source), skip))
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "{skip ")
         skip.append_in(tagged_out_memory)
         tagged_out_memory.extend('}')
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
   make (a_source: like source; a_skip: like skip)
      require
         a_source /= Void
      do
         source := a_source
         skip := a_skip
      ensure
         source = a_source
         skip = a_skip
      end

end -- class MIXUP_SKIP_OCTAVE
