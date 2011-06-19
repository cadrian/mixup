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
class MIXUP_MIDI_TRACK

inherit
   MIXUP_MIDI_ENCODE_CONTEXT

insert
   LOGGING

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
         a_event = end_of_track implies a_time >= max_time
      local
         actual_time: INTEGER_64
         events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]
      do
         actual_time := a_time
         events_at_time := events.fast_reference_at(actual_time)
         if events_at_time = Void then
            create events_at_time.with_capacity(4)
            events.add(events_at_time, actual_time)
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
            debug
               log.trace.put_string("Track #" + id.out + ": at tick " + time.out)
            end
            encode_events(events.item(i), a_stream, (time - current_time).to_integer_32)
            current_time := time
            i := i + 1
         end
      end

   max_time: INTEGER_64 is
      do
         if not events.is_empty then
            Result := events.key(events.upper)
         end
      end

feature {ANY} -- context
   transpose_half_tones: INTEGER_8

   set_transpose_half_tones (a_transpose_half_tones: like transpose_half_tones) is
      do
         transpose_half_tones := a_transpose_half_tones
      end

feature {ANY} -- note ties management
   is_on (pitch: INTEGER_8): BOOLEAN is
      do
         Result := playing_notes.fast_has(pitch)
      end

   turn_on (pitch: INTEGER_8) is
      do
         playing_notes.fast_add(pitch)
      end

   turn_off (pitch: INTEGER_8) is
      do
         playing_notes.fast_remove(pitch)
      end

feature {}
   byte_size_events (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]; delta_time: INTEGER): INTEGER is
      require
         not events_at_time.is_empty
      local
         i, time: INTEGER
         event: MIXUP_MIDI_CODEC
      do
         from
            time := delta_time
            i := events_at_time.lower
         until
            i > events_at_time.upper
         loop
            event := events_at_time.item(i)
            if event.byte_size > 0 then
               Result := Result + event.byte_size_variable(time)
               time := 0
            end
            Result := Result + event.byte_size
            i := i + 1
         end
      end

   encode_events (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]; a_stream: MIXUP_MIDI_OUTPUT_STREAM; delta_time: INTEGER) is
      require
         not events_at_time.is_empty
      local
         i, time: INTEGER
         event: MIXUP_MIDI_CODEC
      do
         debug
            log.trace.put_line(" (delta=" + delta_time.out + ")")
         end
         from
            time := delta_time
            i := events_at_time.lower
         until
            i > events_at_time.upper
         loop
            event := events_at_time.item(i)
            if event.byte_size > 0 then
               a_stream.put_variable(time)
               time := 0
            end
            event.encode_to(a_stream, Current)
            i := i + 1
         end
      end

feature {}
   make is
      do
         create events.make
         id_counter.next
         id := id_counter.item
         create playing_notes.with_capacity(128)
      end

   events: AVL_DICTIONARY[FAST_ARRAY[MIXUP_MIDI_CODEC], INTEGER_64]
   playing_notes: HASHED_SET[INTEGER_8]

   end_of_track: MIXUP_MIDI_META_EVENT is
      local
         meta: MIXUP_MIDI_META_EVENTS
      do
         Result := meta.end_of_track_event
      end

   id: INTEGER

   id_counter: COUNTER is
      once
         create Result
      end

invariant
   id > 0
   events.for_all(agent (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]): BOOLEAN is do Result := not events_at_time.is_empty end)

end -- class MIXUP_MIDI_TRACK
