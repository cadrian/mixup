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
class MIXUP_MIDI_FILE

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   division: INTEGER_16
         -- ticks per quarter

   type: INTEGER_8
         -- MIDI type: 0, 1, or 2

   set_division (a_division: like division)
      require
         a_division > 0
      do
         division := a_division
      ensure
         division = a_division
      end

   add_track (a_track: MIXUP_MIDI_TRACK)
      require
         a_track /= Void
         can_add_track
      do
         tracks.add_last(a_track)
      ensure
         tracks.count = old tracks.count + 1
         tracks.last = a_track
      end

   encode_to (a_stream: MIXUP_MIDI_OUTPUT_STREAM)
      require
         a_stream.is_connected
      local
         tracks_counter: AGGREGATOR[MIXUP_MIDI_TRACK, INTEGER]; tracks_count: INTEGER
      do
         log.trace.put_line(">>>> Start file")
         tracks_count := tracks_counter.map(tracks,
                                            agent (t: MIXUP_MIDI_TRACK; i: INTEGER): INTEGER
                                            then
                                               if t.can_encode then i + 1 else i end
                                            end (?, ?),
                                            0)
         a_stream.start(type, tracks_count.to_integer_16, division)
         tracks.for_each(agent (t: MIXUP_MIDI_TRACK)
                         do
                            if t.can_encode then
                               t.encode_to(a_stream)
                            end
                         end (?))
      end

   can_add_track: BOOLEAN
      do
         Result := tracks.count < 0x00007fff
      end

   max_time: INTEGER_64

   end_all_tracks
      local
         times: AGGREGATOR[MIXUP_MIDI_TRACK, INTEGER_64]
      do
         max_time := times.map(tracks,
                               agent (a_track: MIXUP_MIDI_TRACK; time: INTEGER_64): INTEGER_64
                               do
                                  if a_track.max_time > time then
                                     Result := a_track.max_time
                                  else
                                     Result := time
                                  end
                               end (?, ?),
                               0
                               )
         tracks.for_each(agent (a_track: MIXUP_MIDI_TRACK)
                         local
                            meta: MIXUP_MIDI_META_EVENTS
                         do
                            if a_track.can_add_event then
                               log.trace.put_line("Ending track")
                               a_track.add_event(max_time, meta.end_of_track_event)
                            end
                         end (?))
      ensure
         tracks.for_all(agent (a_track: MIXUP_MIDI_TRACK): BOOLEAN is then not a_track.can_add_event end (?))
      end

   track_count: INTEGER
      do
         Result := tracks.count
      end

   track (index: INTEGER): MIXUP_MIDI_TRACK
      require
         index.in_range(1, track_count)
      do
         Result := tracks.item(index - 1)
      end

feature {}
   make (a_type: like type; a_division: like division)
      require
         a_type.in_range(0, 2)
         a_division > 0
      do
         type := a_type
         set_division(a_division)
         create tracks.make(0)
      ensure
         type = a_type
         division = a_division
      end

   tracks: FAST_ARRAY[MIXUP_MIDI_TRACK]

invariant
   division > 0
   tracks /= Void
   tracks.count <= 0x00007fff

end -- class MIXUP_MIDI_FILE
