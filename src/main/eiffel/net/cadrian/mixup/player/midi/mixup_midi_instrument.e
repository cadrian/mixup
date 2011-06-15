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

feature {}
   make (a_context: like context; a_name: like name; a_voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]; file: MIXUP_MIDI_FILE; a_track_id: like track_id) is
      require
         file /= Void
         a_track_id.in_range(0, 15)
      local
         events: MIXUP_MIDI_EVENTS
         knobs: MIXUP_MIDI_CONTROLLER_KNOBS
      do
         create track.make
         track_id := a_track_id
         file.add_track(track)
         make_abstract(a_context, a_name, a_voice_staff_ids)

         log.info.put_line("MIDI instrument #" + a_track_id.out + ": " + a_name.out)

         track.add_event(0, events.program_change_event(track_id.to_integer_8, 0))
         track.add_event(0, events.controller_event(track_id.to_integer_8, knobs.channel_volume_controller, 64))
         track.add_event(0, events.controller_event(track_id.to_integer_8, knobs.expression_controller, 64))

         debug
            if track_id = 0 then
               track.add_event(0, events.program_change_event(track_id.to_integer_8, 42))
               track.add_event(0, events.controller_event(track_id.to_integer_8, knobs.channel_volume_controller, 64))
               track.add_event(0, events.controller_event(track_id.to_integer_8, knobs.expression_controller, 96))
            end
         end
      end

   new_staff (voice_ids: TRAVERSABLE[INTEGER]; id: INTEGER): MIXUP_MIDI_STAFF is
      do
         create Result.make(id, voice_ids, track, track_id)
      end

   track: MIXUP_MIDI_TRACK
   track_id: INTEGER

invariant
   track_id.in_range(0, 15)

end -- class MIXUP_MIDI_INSTRUMENT
