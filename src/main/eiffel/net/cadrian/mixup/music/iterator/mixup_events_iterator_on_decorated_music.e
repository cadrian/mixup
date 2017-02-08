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
class MIXUP_EVENTS_ITERATOR_ON_DECORATED_MUSIC
   --
   -- Decorated iterator with start and end events
   --

inherit
   MIXUP_EVENTS_CACHED_ITERATOR

create {ANY}
   make

feature {ANY}
   start
      do
         start_event_factory := start_event_factory_
         end_event_factory := end_event_factory_
         events_iterator.start
      end

   is_off: BOOLEAN
      do
         Result := start_event_factory = Void and then events_iterator.is_off and then end_event_factory = Void
      end

feature {}
   fetch_item: MIXUP_EVENT
      do
         if start_event_factory /= Void then
            Result := start_event_factory.item([context])
         elseif not events_iterator.is_off then
            Result := events_iterator.item
            if event_modifier /= Void then
               Result := event_modifier.item([context, Result])
            end
         elseif end_event_factory /= Void then
            Result := end_event_factory.item([context])
         end
      end

   go_next
      do
         if start_event_factory /= Void then
            start_event_factory := Void
         elseif not events_iterator.is_off then
            events_iterator.next
         elseif end_event_factory /= Void then
            end_event_factory := Void
         end
      end

feature {MIXUP_VOICE}
   events_iterator: MIXUP_EVENTS_ITERATOR
   start_event_factory: like start_event_factory_
   end_event_factory: like end_event_factory_

feature {}
   make (a_context: like context; a_start_event_factory: like start_event_factory; a_end_event_factory: like end_event_factory; a_event_modifier: like event_modifier; a_events_iterator: like events_iterator)
      require
         a_events_iterator /= Void
      do
         context := a_context
         start_event_factory_ := a_start_event_factory
         end_event_factory_ := a_end_event_factory
         event_modifier := a_event_modifier
         events_iterator := a_events_iterator
         start
      ensure
         start_event_factory = a_start_event_factory
         end_event_factory = a_end_event_factory
         event_modifier = a_event_modifier
         events_iterator = a_events_iterator
      end

   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   start_event_factory_: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]
   end_event_factory_: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]
   event_modifier: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT, MIXUP_EVENT], MIXUP_EVENT]

invariant
   events_iterator /= Void

end -- class MIXUP_EVENTS_ITERATOR_ON_DECORATED_MUSIC
