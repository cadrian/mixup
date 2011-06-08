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

create {ANY}
   make

feature {ANY}
   division: INTEGER_16

   add_track (a_track: MIXUP_MIDI_EVENTS) is
      require
         a_track /= Void
         can_add_track
      do
         tracks.add_last(a_track)
      ensure
         tracks.count = old tracks.count + 1
         tracks.last = a_track
      end

   encode_to (a_stream: MIXUP_MIDI_OUTPUT_STREAM) is
      require
         a_stream.is_connected
      do
         a_stream.start(tracks.count.to_integer_16, division)
         tracks.do_all(agent {MIXUP_MIDI_EVENTS}.encode_to(a_stream))
      end

   can_add_track: BOOLEAN is
      do
         Result := tracks.count < 0x00007fff
      end

feature {}
   make (a_division: like division) is
      require
         a_division > 0
      do
         division := a_division
         create tracks.make(0)
      ensure
         division = a_division
      end

   tracks: FAST_ARRAY[MIXUP_MIDI_EVENTS]

invariant
   division > 0
   tracks /= Void
   tracks.count <= 0x00007fff

end -- class MIXUP_MIDI_FILE
