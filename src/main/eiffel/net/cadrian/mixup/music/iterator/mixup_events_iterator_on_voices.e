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
class MIXUP_EVENTS_ITERATOR_ON_VOICES
   --
   -- Iterator on parallel voices
   --

inherit
   MIXUP_EVENTS_PARALLEL_ITERATOR
      redefine
         start, is_off, fetch_item, go_next
      end

create {MIXUP_VOICES}
   make

feature {ANY}
   start
      do
         is_start_event_called := False
         is_end_event_called := False
         Precursor
      end

   is_off: BOOLEAN
      do
         Result := is_end_event_called
      end

feature {}
   fetch_item: MIXUP_EVENT
      do
         if not is_start_event_called then
            create {MIXUP_EVENT_START_VOICES} Result.make(context.event_data(source), voice_ids)
         elseif not notes.is_empty then
            Result := Precursor
         else
            create {MIXUP_EVENT_END_VOICES} Result.make(context.event_data(source))
         end
      end

   go_next
      do
         if not is_start_event_called then
            is_start_event_called := True
         elseif not notes.is_empty then
            Precursor
         else
            is_end_event_called := True
         end
      end

   voice_ids: FAST_ARRAY[INTEGER]
      do
         create Result.with_capacity(voices.count)
         voices.do_all(agent (voice: MIXUP_VOICE; ids: FAST_ARRAY[INTEGER])
                          do
                             ids.add_last(voice.id)
                          end(?, Result))
      end

feature {}
   make (a_source: like source; a_context: like context; a_voices: like voices)
      require
         a_source /= Void
         a_voices /= Void
      do
         source := a_source
         context := a_context
         voices := a_voices
         start
      ensure
         source = a_source
         voices = a_voices
      end

   add_notes_iterator
      do
         voices.do_all(agent add_events_iterator)
      end

   add_events_iterator (a_voice: MIXUP_VOICE)
      do
         notes.add_last(a_voice.new_events_iterator(context))
      end

   count: INTEGER
      do
         Result := voices.count
      end

   is_start_event_called: BOOLEAN
   is_end_event_called: BOOLEAN
   source: MIXUP_SOURCE
   voices: TRAVERSABLE[MIXUP_VOICE]
   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   start_time: INTEGER_64

invariant
   source /= Void
   voices /= Void

end -- class MIXUP_EVENTS_ITERATOR_ON_VOICES
