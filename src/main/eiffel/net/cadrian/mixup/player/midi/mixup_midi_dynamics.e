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
deferred class MIXUP_MIDI_DYNAMICS

insert
   LOGGING

feature {ANY}
   velocity (a_time: INTEGER_64): INTEGER_8 is
      deferred
      ensure
         Result >= 0
      end

   first_time: INTEGER_64 is
      do
         if first_note /= Void then
            Result := first_note.time
         end
      end

   last_time: INTEGER_64 is
      do
         Result := last_note.time
      end

   generate (context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION; track: MIXUP_MIDI_TRACK; track_id: INTEGER) is
      require
         context /= Void
         section /= Void
         track /= Void
         track_id.in_range(0, 15)
      deferred
      end

feature {MIXUP_MIDI_DYNAMICS}
   accept (a_dyn: MIXUP_MIDI_DYNAMICS) is
      deferred
      end

   from_nuance (a_nuance: MIXUP_MIDI_DYNAMICS_NUANCE) is
      require
         a_nuance /= Void
      deferred
      end

   from_hairpin (a_hairpin: MIXUP_MIDI_DYNAMICS_HAIRPIN) is
      require
         a_hairpin /= Void
      deferred
      end

feature {MIXUP_MIDI_NOTE}
   add_note (a_note: like first_note) is
      require
         a_note /= Void
      do
         if first_note = Void or else a_note.time < first_note.time then
            first_note := a_note
         end
         if last_note = Void or else a_note.time > last_note.time then
            last_note := a_note
         end
      end

feature {}
   first_note, last_note: MIXUP_MIDI_NOTE

invariant
   last_note /= first_note implies first_note /= Void
   first_note /= Void implies last_note /= Void

end -- class MIXUP_MIDI_DYNAMICS
