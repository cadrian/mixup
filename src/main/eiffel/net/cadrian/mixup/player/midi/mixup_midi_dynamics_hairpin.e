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
class MIXUP_MIDI_DYNAMICS_HAIRPIN

inherit
   MIXUP_MIDI_DYNAMICS

create {ANY}
   make

feature {ANY}
   velocity (a_time: INTEGER_64): INTEGER_8 is
      do
         -- TODO: logarithmic progression instead of linear?
         if stop = Void then
            -- TODO: warning_at(start.source, "Unterminated hairpin")
            Result := start.nuance
         else
            Result := (start.nuance + (stop.nuance - start.nuance) * (a_time - first_time) // (last_time - first_time)).to_integer_8
            log.info.put_line("hairpin: velocity at " + a_time.out + " = " + Result.out
                              + " (from " + first_time.out + ":" + start.nuance.out
                                + " to " + last_time.out + ":" + stop.nuance.out + ")")
         end
      end

   set_stop (a_stop: like stop) is
      require
         a_stop /= Void
      do
         stop := a_stop
      end

   generate (context: MIXUP_CONTEXT; section: MIXUP_MIDI_SECTION; track: MIXUP_MIDI_TRACK; track_id: INTEGER) is
      local
         knobs: MIXUP_MIDI_CONTROLLER_KNOBS
      do
         if stop /= Void then
            track.linear_mpc(track_id, knobs.expression_controller, first_time * section.precision, start.nuance, last_time * section.precision, stop.nuance)
         end
      end

feature {MIXUP_MIDI_DYNAMICS}
   accept (a_dyn: MIXUP_MIDI_DYNAMICS) is
      do
         a_dyn.from_hairpin(Current)
      end

   from_nuance (a_nuance: MIXUP_MIDI_DYNAMICS_NUANCE) is
      do
         start := a_nuance
      end

   from_hairpin (a_hairpin: MIXUP_MIDI_DYNAMICS_HAIRPIN) is
      do
         start := a_hairpin.stop
      end

   start: MIXUP_MIDI_DYNAMICS_NUANCE
   stop: MIXUP_MIDI_DYNAMICS_NUANCE

feature {}
   make (a_start: MIXUP_MIDI_DYNAMICS) is
      require
         a_start /= Void
      do
         a_start.accept(Current)
      end

end -- class MIXUP_MIDI_DYNAMICS_HAIRPIN
