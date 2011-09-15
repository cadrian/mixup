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
class MIXUP_DECORATED_MUSIC

inherit
   MIXUP_MUSIC

create {ANY}
   make

feature {ANY}
   timing: MIXUP_MUSIC_TIMING is
      do
         Result := music.timing
      end

   valid_anchor: BOOLEAN is
      do
         Result := music.valid_anchor
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := music.anchor
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current is
      local
         music_: like music
      do
         music_ := music.commit(a_commit_context)
         create Result.make(source, tag, music_, start_event_factory, end_event_factory, event_modifier)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         debug
            log.trace.put_line(once "Iterating over decorated music: " | tag)
         end
         create {MIXUP_EVENTS_ITERATOR_ON_DECORATED_MUSIC} Result.make(a_context, start_event_factory, end_event_factory, event_modifier, music.new_events_iterator(a_context))
      end

feature {MIXUP_MUSIC, MIXUP_SPANNER}
   add_voice_ids (ids: AVL_SET[INTEGER]) is
      do
         music.add_voice_ids(ids)
      end

   set_timing (a_duration: INTEGER_64; a_first_bar_number: INTEGER; a_bars_count: INTEGER) is
      do
         music.set_timing(a_duration, a_first_bar_number, a_bars_count)
      end

feature {}
   make (a_source: like source; a_tag: like tag; a_music: like music;
         a_start_event_factory: like start_event_factory; a_end_event_factory: like end_event_factory; a_event_modifier: like event_modifier) is
      require
         a_source /= Void
         a_tag /= Void
         a_music /= Void
      do
         source := a_source
         tag := a_tag
         music := a_music
         start_event_factory := a_start_event_factory
         end_event_factory := a_end_event_factory
         event_modifier := a_event_modifier
      ensure
         source = a_source
         music = a_music
         start_event_factory = a_start_event_factory
         end_event_factory = a_end_event_factory
         event_modifier = a_event_modifier
      end

   music: MIXUP_MUSIC
   tag: STRING
   start_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]
   event_modifier: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT, MIXUP_EVENT], MIXUP_EVENT]
   end_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]

invariant
   music /= Void

end -- class MIXUP_DECORATED_MUSIC
