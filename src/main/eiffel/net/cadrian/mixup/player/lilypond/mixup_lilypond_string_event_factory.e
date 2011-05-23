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
   MIXUP_MUSIC

create {MIXUP_LILYPOND_PLAYER}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR) is
      do
         (create {MIXUP_MUSIC_VALUE}.make(source, Current)).accept(visitor)
      end

feature {ANY}
   duration: INTEGER_64 is 0

   valid_anchor: BOOLEAN is False

   anchor: MIXUP_NOTE_HEAD is
      do
         crash
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      do
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_LILYPOND_STRING_EVENT}.make(a_context.event_data(source), string))
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

   add_voice_ids (a_ids: AVL_SET[INTEGER]) is
      do
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
