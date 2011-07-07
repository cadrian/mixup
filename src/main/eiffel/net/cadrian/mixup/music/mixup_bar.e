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
class MIXUP_BAR

inherit
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   timing: MIXUP_MUSIC_TIMING
   style: FIXED_STRING

   valid_anchor: BOOLEAN is False

   anchor: MIXUP_NOTE_HEAD is do end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like Current is
      do
         create Result.make(source, style)
         Result.set_timing(0, a_start_bar_number, 1)
         log.trace.put_string(once "COMMIT: bar: from ")
         log.trace.put_integer(a_start_bar_number)
         log.trace.put_new_line
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_EVENT_NEXT_BAR}.make(a_context.event_data(source), style))
      end

   out_in_tagged_out_memory is
      do
         if style = Void then
            tagged_out_memory.extend('|')
         else
            style.out_in_tagged_out_memory
         end
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   frozen add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         timing := timing.set(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_style: like style) is
      require
         a_source /= Void
      do
         source := a_source
         style := a_style
      ensure
         source = a_source
         style = a_style
      end

end -- class MIXUP_BAR
