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
   duration: INTEGER_64 is
      do
         Result := music.duration
      end

   valid_anchor: BOOLEAN is
      do
         Result := music.valid_anchor
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := music.anchor
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      do
         debug
            log.trace.put_line("Committing decorated music: " + tag)
         end
         music.commit(a_context, a_player)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         debug
            log.trace.put_line("Iterating over decorated music: " + tag)
         end
         create {MIXUP_EVENTS_ITERATOR_ON_DECORATED_MUSIC} Result.make(a_context, start_event_factory, end_event_factory, event_modifier, music.new_events_iterator(a_context))
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
         debug
            log.trace.put_line("Consolidating decorated music: " + tag)
         end
         music.consolidate_bars(bars, duration_offset)
      end

feature {}
   make (a_source: like source; a_tag: like tag; a_music: like music;
         a_start_event_factory: like start_event_factory; a_end_event_factory: like end_event_factory; a_event_modifier: like event_modifier) is
      require
         a_source /= Void
         a_tag /= Void
         a_music /= Void
      do
         debug
            log.trace.put_line("Creating decorated music: " + a_tag)
         end
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

   tag: STRING
   music: MIXUP_MUSIC
   start_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]
   event_modifier: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT, MIXUP_EVENT], MIXUP_EVENT]
   end_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]

invariant
   music /= Void

end -- class MIXUP_DECORATED_MUSIC
