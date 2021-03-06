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
   MIXUP_MIDI_EVENTS
   MIXUP_MIDI_META_EVENTS

create {ANY}
   make

feature {ANY}
   can_add_event: BOOLEAN
      do
         Result := events.is_empty or else events.last.last /= end_of_track_event
      end

   add_event (a_time: INTEGER_64; a_event: MIXUP_MIDI_CODEC)
      require
         can_add_event
         a_event /= Void
         a_event = end_of_track_event implies a_time >= max_time
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

   can_encode: BOOLEAN
      do
         if events.is_empty then
            log.trace.put_line("cannot encode track #(1): is empty" # &id)
         elseif events.last.last /= end_of_track_event then
            log.trace.put_line("cannot encode track #(1): missing end-of-track event" # &id)
         else
            Result := True
         end
      end

   byte_size: INTEGER
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

   encode_to (a_stream: MIXUP_MIDI_OUTPUT_STREAM)
      require
         can_encode
         a_stream.is_connected
      local
         i: INTEGER
         current_time, time: INTEGER_64
      do
         log.trace.put_line(">>>> track #(1): length #(2)" # &id # &byte_size)
         a_stream.next_track(byte_size)
         from
            i := events.lower
         until
            i > events.upper
         loop
            time := events.key(i)
            debug
               log.trace.put_string(once "Track #" | &id | once ": at tick " | &time)
            end
            encode_events(events.item(i), a_stream, (time - current_time).to_integer_32)
            current_time := time
            i := i + 1
         end
      end

   max_time: INTEGER_64
      do
         if not events.is_empty then
            Result := events.key(events.upper)
         end
      end

   new_iterator: MIXUP_MIDI_TRACK_ITERATOR
      do
         create Result.make(events)
      end

feature {ANY} -- playing notes
   is_on (channel, pitch: INTEGER_8): BOOLEAN
      do
         Result := playing_notes(channel).fast_has(pitch)
      end

   turn_on (channel: INTEGER_8; time: INTEGER_64; pitch: INTEGER_8; duration: INTEGER_64; velocity: INTEGER_8)
      do
         if not is_on(channel, pitch) then
            add_event(time, note_event(channel, True, pitch, velocity))
         end
         playing_notes(channel).fast_put(duration, pitch)
      ensure
         is_on(channel, pitch)
      end

   turn_off (channel: INTEGER_8; time: INTEGER_64; pitch: INTEGER_8; velocity: INTEGER_8)
      local
         stop_time: INTEGER_64
      do
         if is_on(channel, pitch) then
            stop_time := time + playing_notes(channel).fast_at(pitch)
            add_event(stop_time, note_event(channel, False, pitch, velocity))
         end
         playing_notes(channel).fast_remove(pitch)
      ensure
         not is_on(channel, pitch)
      end

   linear_mpc (track_id: INTEGER; a_knob: MIXUP_MIDI_CONTROLLER_KNOB; a_start_time: INTEGER_64; a_start_value: INTEGER_8; a_end_time: INTEGER_64; a_end_value: INTEGER_8)
      require
         a_start_value >= 0
         a_end_value >= 0
      local
         count: INTEGER
         sensible_end_time: INTEGER_64
         log_info: OUTPUT_STREAM
      do
         count := a_end_value - a_start_value + 1
         if count < 0 then
            count := -count
         end
         if count > a_end_time - a_start_time then
            count := (a_end_time - a_start_time + 1).to_integer_32
         end
         sensible_end_time := a_end_time - (a_end_time - a_start_time) \\ count

         log_info := log.info
         log_info.put_string(once "Playing MPC ")
         log_info.put_string(a_knob.name)
         log_info.put_string(once ": from time ")
         log_info.put_integer(a_start_time)
         log_info.put_string(once " (value: ")
         log_info.put_integer(a_start_value)
         log_info.put_string(once ") to time ")
         log_info.put_integer(sensible_end_time)
         debug
            log_info.put_string(once " [raw: ")
            log_info.put_integer(a_end_time)
            log_info.put_string(once "]")
         end
         log_info.put_string(once " (value: ")
         log_info.put_integer(a_end_value)
         log_info.put_line(once ")")

         add_multi_point_controller(track_id.to_integer_8, a_start_time, sensible_end_time, count, a_knob, agent linear_curve(?, count, a_start_value, a_end_value))
      end

feature {}
   add_multi_point_controller (channel: INTEGER_8; start_time, end_time: INTEGER_64; count: INTEGER; knob: MIXUP_MIDI_CONTROLLER_KNOB; curve: FUNCTION[TUPLE[INTEGER], INTEGER])
         -- Idea coming right from NoteWorthy Composer: the "MPC". That's the most user-friendly MIDI tool I ever used.
      require
         time_direction: end_time >= start_time
         sensible_count: count >= 1
         sensible_division: start_time + ((end_time - start_time) // count) * count = end_time
      local
         i, value: INTEGER
         time, delta: INTEGER_64
         log_info: OUTPUT_STREAM

      do
         log_info := log.info
         from
            time := start_time
            delta := (end_time - start_time) // count
            i := 1
         until
            i > count
         loop
            value := curve.item([i])

            log_info.put_string(once " at ")
            log_info.put_integer(time)
            log_info.put_string(once ": value=")
            log_info.put_integer(value)
            log_info.put_new_line

            add_event(time, controller_event(channel, knob, value))
            time := time + delta
            i := i + 1
         end
      end

   linear_curve (value: INTEGER; count, start_value, end_value: INTEGER): INTEGER
      require
         start_value.in_range(0, 127)
         end_value.in_range(0, 127)
      do
         if end_value < start_value then
            Result := (start_value - value) * (start_value - end_value) // count
         else
            Result := (start_value + value) * (end_value - start_value) // count
         end
      end

feature {ANY} -- encode context
   transpose_half_tones: INTEGER_8

   set_transpose_half_tones (a_transpose_half_tones: like transpose_half_tones)
      do
         transpose_half_tones := a_transpose_half_tones
      end

feature {}
   byte_size_events (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]; delta_time: INTEGER): INTEGER
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

   encode_events (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]; a_stream: MIXUP_MIDI_OUTPUT_STREAM; delta_time: INTEGER)
      require
         not events_at_time.is_empty
      local
         i, time: INTEGER
         event: MIXUP_MIDI_CODEC
      do
         debug
            log.trace.put_line(once " (delta=" | &delta_time | once ")")
         end
         from
            time := delta_time
            i := events_at_time.lower
         until
            i > events_at_time.upper
         loop
            event := events_at_time.item(i)
            if event.byte_size > 0 then
               log.trace.put_line(">>>> time: #(1)" # time.out)
               a_stream.put_variable(time)
               time := 0
            end
            log.trace.put_line(">>>> event: #(1)" # event.out)
            event.encode_to(a_stream, Current)
            i := i + 1
         end
      end

feature {}
   make
      do
         create events.make
         id_counter.next
         id := id_counter.item
         create playing_notes_.make
      end

   events: AVL_DICTIONARY[FAST_ARRAY[MIXUP_MIDI_CODEC], INTEGER_64]
   playing_notes_: AVL_DICTIONARY[HASHED_DICTIONARY[INTEGER_64, INTEGER_8], INTEGER_8]

   playing_notes (channel: INTEGER_8): HASHED_DICTIONARY[INTEGER_64, INTEGER_8]
      require
         channel.in_range(0, 15)
      do
         Result := playing_notes_.reference_at(channel)
         if Result = Void then
            create Result.with_capacity(128)
            playing_notes_.add(Result, channel)
         end
      ensure
         Result /= Void
      end

   id: INTEGER

   id_counter: COUNTER
      once
         create Result
      end

invariant
   id > 0
   events.for_all(agent (events_at_time: FAST_ARRAY[MIXUP_MIDI_CODEC]): BOOLEAN is do Result := not events_at_time.is_empty end (?))

end -- class MIXUP_MIDI_TRACK
