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
class MIXUP_MIDI_EVENTS_TO_SEND

inherit
   MIXUP_MIDI_ITEM

create {ANY}
   make

feature {ANY}
   generate (context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION)
      do
         events.do_all(agent (a_time: INTEGER_64; a_event: FUNCTION[TUPLE[INTEGER_8], MIXUP_MIDI_EVENT])
                       do
                          track.add_event(a_time, a_event.item([track_id.to_integer_8]))
                       end(time * section.precision, ?))
      end

feature {}
   make (a_time: like time; a_events: like events; a_track: like track; a_track_id: like track_id)
      require
         a_events /= Void
         a_track /= Void
         a_track_id.in_range(0, 15)
      do
         time := a_time
         events := a_events
         track := a_track
         track_id := a_track_id
      ensure
         time = a_time
         events = a_events
         track = a_track
         track_id = a_track_id
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER
   events: HOARD[FUNCTION[TUPLE[INTEGER_8], MIXUP_MIDI_EVENT]]

invariant
   events /= Void
   track /= Void
   track_id.in_range(0, 15)

end -- class MIXUP_MIDI_EVENTS_TO_SEND
