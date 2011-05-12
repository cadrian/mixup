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
expanded class AUX_MIXUP_MOCK_PLAYER_EVENTS

feature {}
   set_score (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_score".intern, [name.intern])
      end

   end_score: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_score".intern, [])
      end

   set_book (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_book".intern, [name.intern])
      end

   end_book: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_book".intern, [])
      end

   set_partitur (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_partitur".intern, [name.intern])
      end

   end_partitur: AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_partitur".intern, [])
      end

   set_instrument (name: ABSTRACT_STRING; a_voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_instrument".intern, [name.intern, a_voice_staff_ids])
      end

   set_dynamics (instrument: ABSTRACT_STRING; a_staff_id: INTEGER; dynamics, position: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         pos: FIXED_STRING
      do
         if position /= Void then
            pos := position.intern
         end
         create Result.make("set_dynamics".intern, [instrument.intern, a_staff_id, dynamics.intern, pos])
      end

   set_note (instrument: ABSTRACT_STRING; a_staff_id: INTEGER; note: MIXUP_NOTE): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_note".intern, [instrument.intern, a_staff_id, note])
      end

   next_bar (instrument: ABSTRACT_STRING; a_staff_id: INTEGER; style: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         sty: FIXED_STRING
      do
         if style /= Void then
            sty := style.intern
         end
         create Result.make("next_bar".intern, [instrument.intern, a_staff_id, sty])
      end

   start_beam (instrument: ABSTRACT_STRING; a_staff_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         t: FIXED_STRING
      do
         if text /= Void then
            t := text.intern
         end
         create Result.make("start_beam".intern, [instrument.intern, a_staff_id, xuplet_numerator, xuplet_denominator, t])
      end

   end_beam (instrument: ABSTRACT_STRING; a_staff_id: INTEGER): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_beam".intern, [instrument.intern, a_staff_id])
      end

   start_slur (instrument: ABSTRACT_STRING; a_staff_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         t: FIXED_STRING
      do
         if text /= Void then
            t := text.intern
         end
         create Result.make("start_slur".intern, [instrument.intern, a_staff_id, xuplet_numerator, xuplet_denominator, t])
      end

   end_slur (instrument: ABSTRACT_STRING; a_staff_id: INTEGER): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_slur".intern, [instrument.intern, a_staff_id])
      end

   start_phrasing_slur (instrument: ABSTRACT_STRING; a_staff_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         t: FIXED_STRING
      do
         if text /= Void then
            t := text.intern
         end
         create Result.make("start_phrasing_slur".intern, [instrument.intern, a_staff_id, xuplet_numerator, xuplet_denominator, t])
      end

   end_phrasing_slur (instrument: ABSTRACT_STRING; a_staff_id: INTEGER): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_phrasing_slur".intern, [instrument.intern, a_staff_id])
      end

   start_repeat (instrument: ABSTRACT_STRING; a_staff_id: INTEGER; volte: INTEGER_64): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("start_repeat".intern, [instrument.intern, a_staff_id, volte])
      end

   end_repeat (instrument: ABSTRACT_STRING; a_staff_id: INTEGER): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_repeat".intern, [instrument.intern, a_staff_id])
      end

end -- class AUX_MIXUP_MOCK_PLAYER_EVENTS
