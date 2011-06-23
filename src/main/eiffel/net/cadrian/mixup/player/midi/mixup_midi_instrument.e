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
class MIXUP_MIDI_INSTRUMENT

inherit
   MIXUP_ABSTRACT_INSTRUMENT[MIXUP_MIDI_OUTPUT_STREAM,
                         MIXUP_MIDI_SECTION,
                         MIXUP_MIDI_ITEM,
                         MIXUP_MIDI_VOICE,
                         MIXUP_MIDI_VOICES,
                         MIXUP_MIDI_STAFF
                         ]
      rename
         make as make_abstract
      end

insert
   LOGGING

create {ANY}
   make

feature {MIXUP_MIDI_PLAYER}
   send_events (a_time: INTEGER_64; a_staff_id, a_voice_id: INTEGER; a_events: HOARD[FUNCTION[TUPLE[INTEGER_8], MIXUP_MIDI_EVENT]]) is
      require
         a_events /= Void
      do
         staffs.reference_at(a_staff_id).send_events(a_time, a_voice_id, a_events)
      end

   transpose (a_time: INTEGER_64; a_half_tones: INTEGER_8) is
      do
         track.add_event(a_time, create {MIXUP_MIDI_TRANSPOSE_EVENT}.make(a_half_tones))
      end

   mpc (a_knob: MIXUP_MIDI_CONTROLLER_KNOB; a_start_time: INTEGER_64; a_start_value: INTEGER_8; a_end_time: INTEGER_64; a_end_value: INTEGER_8) is
      require
         a_start_value >= 0
         a_end_value >= 0
      local
         count: INTEGER
         sensible_end_time: INTEGER_64
         log_info: OUTPUT_STREAM
      do
         count := a_end_value - a_start_value
         if count < 0 then
            count := -count
         end
         if count > a_end_time - a_start_time then
            count := (a_end_time - a_start_time).to_integer_32
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

         track.add_multi_point_controller(track_id.to_integer_8, a_start_time, sensible_end_time, count, a_knob, agent linear_mpc(?, count, a_start_value, a_end_value))
      end

feature {}
   make (a_context: like context; a_name: like name; a_voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]; file: MIXUP_MIDI_FILE; a_track_id: like track_id) is
      require
         file /= Void
         a_track_id.in_range(0, 15)
      do
         log.info.put_line("MIDI instrument #" + a_track_id.out + ": " + a_name.out)
         create track.make
         track_id := a_track_id
         file.add_track(track)
         make_abstract(a_context, a_name, a_voice_staff_ids)
      end

   new_staff (voice_ids: TRAVERSABLE[INTEGER]; id: INTEGER): MIXUP_MIDI_STAFF is
      do
         create Result.make(id, voice_ids, track, track_id)
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

   linear_mpc (value: INTEGER; count, start_value, end_value: INTEGER): INTEGER is
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

invariant
   track_id.in_range(0, 15)

end -- class MIXUP_MIDI_INSTRUMENT
