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
class MIXUP_MIDI_SEND_EVENTS

inherit
   MIXUP_EVENT_WITH_DATA
      rename
         make as make_
      redefine
         out_in_extra_data
      end
   MIXUP_EVENT_WITHOUT_LYRICS

create {MIXUP_MIDI_SEND_EVENTS_FACTORY}
   make

feature {ANY}
   needs_instrument: BOOLEAN is False

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER)
      local
         p: MIXUP_MIDI_PLAYER
      do
         p ::= player
         p.play_send_events(data, events)
      end

feature {}
   make (a_data: like data; a_events: like events)
      require
         a_events /= Void
      do
         make_(a_data)
         events := a_events
      ensure
         events = a_events
      end

   out_in_extra_data
      do
         tagged_out_memory.append(once ", events=")
         events.out_in_tagged_out_memory
      end

   events: HOARD[FUNCTION[TUPLE[INTEGER_8], MIXUP_MIDI_EVENT]]

invariant
   events /= Void

end -- class MIXUP_MIDI_SEND_EVENTS
