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
deferred class MIXUP_CONTEXT_VISITOR

inherit
   VISITOR

feature {MIXUP_SCORE}
   start_score (a_score: MIXUP_SCORE) is
      require
         a_score /= Void
      do
      end

   end_score (a_score: MIXUP_SCORE) is
      require
         a_score /= Void
      do
      end

feature {MIXUP_BOOK}
   start_book (a_book: MIXUP_BOOK) is
      require
         a_book /= Void
      do
      end

   end_book (a_book: MIXUP_BOOK) is
      require
         a_book /= Void
      do
      end

feature {MIXUP_PARTITUR}
   start_partitur (a_partitur: MIXUP_PARTITUR) is
      require
         a_partitur /= Void
      do
      end

   end_partitur (a_partitur: MIXUP_PARTITUR) is
      require
         a_partitur /= Void
      do
      end

feature {MIXUP_INSTRUMENT}
   start_instrument (a_instrument: MIXUP_INSTRUMENT) is
      require
         a_instrument /= Void
      do
      end

   end_instrument (a_instrument: MIXUP_INSTRUMENT) is
      require
         a_instrument /= Void
      do
      end

end -- class MIXUP_CONTEXT_VISITOR
