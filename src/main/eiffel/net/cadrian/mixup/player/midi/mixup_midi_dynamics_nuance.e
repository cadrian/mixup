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
class MIXUP_MIDI_DYNAMICS_NUANCE

inherit
   MIXUP_MIDI_DYNAMICS
      redefine
         default_create
      end

create {ANY}
   make, default_create

feature {ANY}
   velocity (a_time: INTEGER_64): INTEGER_8 is
      do
         Result := nuance
         log.info.put_line("nuance: velocity at " + a_time.out + " = " + Result.out)
      end

   generate (context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION; track: MIXUP_MIDI_TRACK; track_id: INTEGER) is
      local
         events: MIXUP_MIDI_EVENTS
         knobs: MIXUP_MIDI_CONTROLLER_KNOBS
      do
         track.add_event(first_time * section.precision, events.controller_event(track_id.to_integer_8, knobs.expression_controller, nuance))
      end

feature {MIXUP_MIDI_DYNAMICS}
   accept (a_dyn: MIXUP_MIDI_DYNAMICS) is
      do
         a_dyn.from_nuance(Current)
      end

   from_nuance (a_nuance: MIXUP_MIDI_DYNAMICS_NUANCE) is
      do
         if nuance = -1 then
            nuance := a_nuance.nuance
         end
      end

   from_hairpin (a_hairpin: MIXUP_MIDI_DYNAMICS_HAIRPIN) is
      do
         if hairpin = Void then
            hairpin := a_hairpin
            a_hairpin.set_stop(Current)
            a_hairpin.start.accept(Current)
         else
            a_hairpin.stop.accept(Current)
         end
      end

   hairpin: MIXUP_MIDI_DYNAMICS_HAIRPIN
   nuance: INTEGER_8

feature {}
   make (from_dynamics: MIXUP_MIDI_DYNAMICS; dyn: ABSTRACT_STRING) is
      require
         from_dynamics /= Void
         dyn /= Void
      do
         nuance := dynamics.fast_at(dyn.intern)
         from_dynamics.accept(Current)
      end

   default_create is
      do
         nuance := 64
      end

   dynamics: HASHED_DICTIONARY[INTEGER_8, FIXED_STRING] is
      once
         Result := {HASHED_DICTIONARY[INTEGER_8, FIXED_STRING]
         <<
           124, "fff".intern;
            96,  "ff".intern;
            80,   "f".intern;
            68,  "mf".intern;
            60,  "mp".intern;
            48,   "p".intern;
            32,  "pp".intern;
             4, "ppp".intern;
            -1, "end".intern;
           >>}
      end

end -- class MIXUP_MIDI_DYNAMICS_NUANCE
