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
class MIXUP_MIDI_EVENTS

create {ANY}
   make

feature {ANY}
   can_add_event: BOOLEAN is
      do
         Result := events.is_empty or else events.last.last /= end_of_track
      end

   add_event (a_time: INTEGER_64; a_event: MIXUP_MIDI_CODEC) is
      require
         can_add_event
         a_event /= Void
      local
         events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]
      do
         events_at_time := events.fast_reference_at(a_time)
         if events_at_time = Void then
            create events_at_time.with_capacity(4)
            events.add(events_at_time, a_time)
         end
         events_at_time.add_last(a_event)
      ensure
         events.fast_reference_at(a_time).last = a_event
      end

   can_encode: BOOLEAN is
      do
         Result := not events.is_empty and then events.last.last = end_of_track
      end

   byte_size: INTEGER is
      require
         can_encode
      local
         i: INTEGER
         current_time, time: INTEGER_64
      do
         from
            i := events.lower
         until
            i > events.upper
         loop
            time := events.key(i)
            Result := Result + byte_size_events(events.item(i), (time - current_time).to_integer_32)
            current_time := time
            i := i + 1
         end
      end

   encode_to (a_stream: MIXUP_MIDI_OUTPUT_STREAM) is
      require
         can_encode
         a_stream.is_connected
      local
         i: INTEGER
         current_time, time: INTEGER_64
      do
         a_stream.next_track(byte_size)
         from
            i := events.lower
         until
            i > events.upper
         loop
            time := events.key(i)
            encode_events(events.item(i), a_stream, (time - current_time).to_integer_32)
            current_time := time
            i := i + 1
         end
      end

feature {}
   byte_size_events (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]; initial_time: INTEGER): INTEGER is
      local
         time: INTEGER
         i: INTEGER
         event: MIXUP_MIDI_CODEC
      do
         from
            time := initial_time
            i := events_at_time.lower
         until
            i > events_at_time.upper
         loop
            event := events_at_time.item(i)
            Result := Result + event.byte_size_variable(time) + event.byte_size
            time := 0
            i := i + 1
         end
      end

   encode_events (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]; a_stream: MIXUP_MIDI_OUTPUT_STREAM; initial_time: INTEGER) is
      local
         time: INTEGER
         i: INTEGER
      do
         from
            time := initial_time
            i := events_at_time.lower
         until
            i > events_at_time.upper
         loop
            a_stream.put_variable(time)
            events_at_time.item(i).encode_to(a_stream)
            time := 0
            i := i + 1
         end
      end

feature {}
   make is
      do
         create events.make
      end

   events: AVL_DICTIONARY[FAST_ARRAY[MIXUP_MIDI_CODEC], INTEGER_64]

   end_of_track: MIXUP_MIDI_META_EVENT is
      local
         meta: MIXUP_MIDI_META_EVENTS
      do
         Result := meta.end_of_track_event
      end

invariant
   events /= Void

end -- class MIXUP_MIDI_EVENTS
