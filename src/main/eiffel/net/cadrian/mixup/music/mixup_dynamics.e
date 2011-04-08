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

create {ANY}
   make

feature {ANY}
   valid_anchor: BOOLEAN is False

   duration: INTEGER_64 is 0
   anchor: MIXUP_NOTE_HEAD is do end
   text: FIXED_STRING
   position: FIXED_STRING

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number: INTEGER): INTEGER is
      do
         debug
            log.trace.put_line("Committing dynamics: " + out)
         end
         Result := start_bar_number
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_EVENT_SET_DYNAMICS}.make(source, a_context.start_time, a_context.instrument.name, text, position))
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   frozen consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

feature {}
   make (a_source: like source; a_text, a_position: FIXED_STRING) is
      require
         a_source /= Void
         a_text /= Void
      do
         source := a_source
         text := a_text
         position := a_position
      ensure
         source = a_source
         text = a_text
         position = a_position
      end

invariant
   text /= Void

end -- class MIXUP_DYNAMICS
