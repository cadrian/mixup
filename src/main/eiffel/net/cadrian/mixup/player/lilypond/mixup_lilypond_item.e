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
deferred class MIXUP_LILYPOND_ITEM

inherit
   MIXUP_ABSTRACT_ITEM[MIXUP_LILYPOND_OUTPUT, MIXUP_LILYPOND_SECTION]

feature {ANY}
   valid_reference: BOOLEAN
      deferred
      ensure
         Result implies not reference.is_rest
      end

   reference: MIXUP_NOTE_HEAD
      require
         valid_reference
      deferred
      ensure
         not Result.is_rest
      end

   can_append: BOOLEAN
      deferred
      end

   append_first (a_string: ABSTRACT_STRING)
      require
         can_append
         a_string /= Void
      deferred
      end

   append_last (a_string: ABSTRACT_STRING)
      require
         can_append
         a_string /= Void
      deferred
      end

end -- class MIXUP_LILYPOND_ITEM
