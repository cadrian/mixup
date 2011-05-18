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
expanded class MIXUP_SYLLABLE

insert
   ANY
      redefine
         is_equal
      end

feature {ANY}
   source: MIXUP_SOURCE
   syllable: FIXED_STRING
   in_word: BOOLEAN

   set (a_source: like source; a_syllable: like syllable; a_in_word: like in_word) is
      require
         not_set: syllable = Void
         settable: a_syllable /= Void
         with_source: a_source /= Void
      do
         source := a_source
         syllable := a_syllable
         in_word := a_in_word
      ensure
         is_set: syllable = a_syllable
         is_linked: in_word = a_in_word
         is_sourced: source = a_source
      end

   is_equal (other: like Current): BOOLEAN is
      do
         Result := syllable = other.syllable and then in_word = other.in_word
      end

end -- class MIXUP_SYLLABLE
