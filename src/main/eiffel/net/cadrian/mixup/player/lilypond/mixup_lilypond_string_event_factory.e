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
class MIXUP_LILYPOND_STRING_EVENT_FACTORY

inherit
   MIXUP_VALUE
      redefine
         out_in_tagged_out_memory
      end
   MIXUP_MUSIC
      redefine
         out_in_tagged_out_memory
      end

create {MIXUP_LILYPOND_PLAYER, MIXUP_LILYPOND_STRING_EVENT_FACTORY}
   make

feature {ANY}
   timing: MIXUP_MUSIC_TIMING
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR) is
      do
         (create {MIXUP_MUSIC_VALUE}.make(source, Current)).accept(visitor)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(once "{MIXUP_LILYPOND_STRING_EVENT_FACTORY %"")
         string.out_in_tagged_out_memory
         tagged_out_memory.append(once "%"}")
      end

feature {ANY}
   valid_anchor: BOOLEAN is False

   anchor: MIXUP_NOTE_HEAD is
      do
         crash
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like Current is
      do
         create Result.make(source, string)
         Result.set_timing(0, a_start_bar_number, 0)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_LILYPOND_STRING_EVENT}.make(a_context.event_data(source), string))
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   add_voice_ids (a_ids: AVL_SET[INTEGER]) is
      do
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         timing := timing.set(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_string: like string) is
      require
         a_source /= Void
         a_string /= Void
      do
         source := a_source
         string := a_string
      ensure
         source = a_source
         string = a_string
      end

   string: FIXED_STRING

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(once "<string_event>")
      end

invariant
   string /= Void

end -- class MIXUP_LILYPOND_STRING_EVENT_FACTORY
