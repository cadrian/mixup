-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_MUSIC_IDENTIFIER

inherit
   MIXUP_MUSIC

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   duration: INTEGER_64 is
      do
         Result := music.duration
      end

   valid_anchor: BOOLEAN is
      do
         Result := music /= Void
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := music.anchor
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      local
         music_value: MIXUP_MUSIC_VALUE
         value: MIXUP_VALUE
      do
         debug
            log.trace.put_line("Committing music identifier: " + identifier.as_name)
         end
         value := a_context.resolver.resolve(identifier, a_player)
         if value = Void then
            not_yet_implemented -- error: unresolved identifier
         elseif music_value ?:= value then
            music_value ::= value
            music := music_value.value
            debug
               log.trace.put_line("    => " + music.out)
            end
         else
            not_yet_implemented -- error: the identifier is not music!
         end
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         debug
            log.trace.put_line("New events iterator for music identifier: " + identifier.as_name)
         end
         Result := music.new_events_iterator(a_context)
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
         debug
            log.trace.put_line("Consolidate bars for music identifier: " + identifier.as_name)
         end
         music.consolidate_bars(bars, duration_offset)
      end

feature {}
   make (a_identifier: MIXUP_IDENTIFIER) is
      require
         a_identifier /= Void
      do
         debug
            log.trace.put_line("Creating music identifier: " + a_identifier.as_name)
         end
         identifier := a_identifier
      ensure
         identifier = a_identifier
      end

   identifier: MIXUP_IDENTIFIER
   music: MIXUP_MUSIC

invariant
   identifier /= Void

end -- class MIXUP_MUSIC_IDENTIFIER
