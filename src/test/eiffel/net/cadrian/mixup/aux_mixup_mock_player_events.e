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

   set_instrument (name: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_instrument".intern, [name.intern])
      end

   set_dynamics (instrument_name: ABSTRACT_STRING; dynamics, position: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         pos: FIXED_STRING
      do
         if position /= Void then
            pos := position.intern
         end
         create Result.make("set_dynamics".intern, [instrument_name.intern, dynamics.intern, pos])
      end

   set_note (instrument: ABSTRACT_STRING; note: MIXUP_NOTE): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("set_note".intern, [instrument.intern, note])
      end

   next_bar (instrument, style: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         sty: FIXED_STRING
      do
         if style /= Void then
            sty := style.intern
         end
         create Result.make("next_bar".intern, [instrument.intern, sty])
      end

   start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         t: FIXED_STRING
      do
         if text /= Void then
            t := text.intern
         end
         create Result.make("start_beam".intern, [instrument.intern, xuplet_numerator, xuplet_denominator, t])
      end

   end_beam (instrument: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_beam".intern, [instrument.intern])
      end

   start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         t: FIXED_STRING
      do
         if text /= Void then
            t := text.intern
         end
         create Result.make("start_slur".intern, [instrument.intern, xuplet_numerator, xuplet_denominator, t])
      end

   end_slur (instrument: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_slur".intern, [instrument.intern])
      end

   start_tie (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      local
         t: FIXED_STRING
      do
         if text /= Void then
            t := text.intern
         end
         create Result.make("start_tie".intern, [instrument.intern, xuplet_numerator, xuplet_denominator, t])
      end

   end_tie (instrument: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_tie".intern, [instrument.intern])
      end

   start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("start_repeat".intern, [instrument.intern, volte])
      end

   end_repeat (instrument: ABSTRACT_STRING): AUX_MIXUP_MOCK_EVENT is
      do
         create Result.make("end_repeat".intern, [instrument.intern])
      end

end -- class AUX_MIXUP_MOCK_PLAYER_EVENTS
