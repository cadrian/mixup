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
class MIXUP_MIDI_SECTION

inherit
   MIXUP_ABSTRACT_SECTION[MIXUP_MIDI_OUTPUT_STREAM]

insert
   MIXUP_NOTE_DURATIONS

create {ANY}
   make

feature {ANY}
   generate (a_output: MIXUP_MIDI_OUTPUT_STREAM) is
      do
         file.end_all_tracks
         file.encode_to(a_output)
      end

   filename_in (a_filename: STRING) is
      require
         a_filename /= Void
      do
         a_filename.precede('-')
         a_filename.prepend(name)
         if parent /= Void then
            parent.filename_in(a_filename)
         end
      end

   precision: INTEGER_8

   set_precision (a_precision: like precision) is
      require
         a_precision > 0
         (duration_4 * precision).fit_integer_16
      do
         precision := a_precision
         file.set_division((duration_4 * precision).to_integer_16)
      ensure
         precision = a_precision
      end

   send_meta_events (a_time: INTEGER_64; a_events: HOARD[MIXUP_MIDI_META_EVENT]) is
      require
         a_events /= Void
      do
         a_events.do_all(agent track0.add_event(a_time, ?))
      end

feature {ANY}
   new_instrument (context: MIXUP_CONTEXT; a_name: FIXED_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]; track_id: INTEGER): MIXUP_MIDI_INSTRUMENT is
      do
         create Result.make(context, a_name, voice_staff_ids, file, track_id)
      end

feature {}
   make (section, a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         name := a_name.intern
         parent := a_parent
         create file.make(768)
         set_precision(12)
         create track0.make
         file.add_track(track0)
      end

   file: MIXUP_MIDI_FILE
   track0: MIXUP_MIDI_TRACK

end -- class MIXUP_MIDI_SECTION
