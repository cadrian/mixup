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
deferred class MIXUP_ABSTRACT_INSTRUMENT[OUT_ -> MIXUP_ABSTRACT_OUTPUT, SEC_ -> MIXUP_ABSTRACT_SECTION[OUT_]]

feature {ANY}
   name: FIXED_STRING is
      deferred
      end

feature {MIXUP_ABSTRACT_PLAYER}
   start_voices (a_staff_id, a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]) is
      deferred
      end

   end_voices (a_staff_id, a_voice_id: INTEGER) is
      deferred
      end

   set_dynamics (a_staff_id, a_voice_id: INTEGER; dynamics, position: ABSTRACT_STRING) is
      deferred
      end

   set_note (a_staff_id, a_voice_id: INTEGER; time: INTEGER_64; note: MIXUP_NOTE) is
      deferred
      end

   next_bar (a_staff_id, a_voice_id: INTEGER; style: ABSTRACT_STRING) is
      deferred
      end

   start_beam (a_staff_id, a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      deferred
      end

   end_beam (a_staff_id, a_voice_id: INTEGER) is
      deferred
      end

   start_slur (a_staff_id, a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      deferred
      end

   end_slur (a_staff_id, a_voice_id: INTEGER) is
      deferred
      end

   start_phrasing_slur (a_staff_id, a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      deferred
      end

   end_phrasing_slur (a_staff_id, a_voice_id: INTEGER) is
      deferred
      end

   start_repeat (a_staff_id, a_voice_id: INTEGER; volte: INTEGER_64) is
      deferred
      end

   end_repeat (a_staff_id, a_voice_id: INTEGER) is
      deferred
      end

feature {MIXUP_ABSTRACT_PLAYER}
   generate (section: SEC_) is
      require
         section /= Void
      deferred
      end

end -- class MIXUP_ABSTRACT_INSTRUMENT
