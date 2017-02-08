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
class MIXUP_MIDI_SEND_META_EVENTS_FACTORY

inherit
   MIXUP_MIDI_MUSIC_EVENTS_FACTORY

create {MIXUP_MIDI_PLAYER}
   make

feature {ANY}
   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "{MIXUP_MIDI_SEND_EVENTS_FACTORY ")
         events.out_in_tagged_out_memory
         tagged_out_memory.append(once "}")
      end

feature {ANY}
   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_MIDI_SEND_META_EVENTS}.make(a_context.event_data(source), events))
      end

   add_event (a_event: MIXUP_MIDI_META_EVENT)
      require
         a_event /= Void
      do
         events.add_last(a_event)
      end

feature {}
   make (a_source: like source)
      require
         a_source /= Void
      do
         source := a_source
         create events.with_capacity(2)
      ensure
         source = a_source
      end

   events: FAST_ARRAY[MIXUP_MIDI_META_EVENT]

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING)
      do
         a_name.append(once "<send_meta_events>")
      end

invariant
   events /= Void

end -- class MIXUP_MIDI_SEND_EVENTS_FACTORY
