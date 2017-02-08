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
class MIXUP_MIDI_TRACK_ITERATOR

create {MIXUP_MIDI_TRACK}
   make

feature {ANY}
   is_off: BOOLEAN
      do
         Result := events = Void
      ensure
         not Result implies events /= Void
      end

   next
      require
         not is_off
      do
         events.next
         if events.is_off then
            time_events.next
            set_events
         end
      end

   event: MIXUP_MIDI_CODEC
      require
         not is_off
      do
         Result := events.item
      end

   time: INTEGER_64
      require
         not is_off
      do
         Result := time_events.item.second
      end

   start
      do
         time_events.start
         set_events
      end

feature {}
   make (a_events: MAP[ITERABLE[MIXUP_MIDI_CODEC], INTEGER_64])
      require
         a_events /= Void
         a_events.for_all(agent (i: ITERABLE[MIXUP_MIDI_CODEC]): BOOLEAN then i /= Void end (?))
      do
         time_events := a_events.new_iterator
      ensure
         wants_start: is_off
      end

   set_events
      do
         if time_events.is_off then
            events := Void
         else
            events := time_events.item.first.new_iterator
            events.start
         end
      end

   time_events: ITERATOR[TUPLE[ITERABLE[MIXUP_MIDI_CODEC], INTEGER_64]]
   events: ITERATOR[MIXUP_MIDI_CODEC]

invariant
   time_events /= Void

end -- class MIXUP_MIDI_TRACK_ITERATOR
