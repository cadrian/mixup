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

feature {ANY}
   valid_reference: BOOLEAN is
      deferred
      end

   reference: MIXUP_NOTE_HEAD is
      require
         valid_reference
      deferred
      ensure
         not Result.is_rest
      end

   can_append: BOOLEAN is
      deferred
      end

   append_first (a_string: ABSTRACT_STRING) is
      require
         can_append
         a_string /= Void
      deferred
      end

   append_last (a_string: ABSTRACT_STRING) is
      require
         can_append
         a_string /= Void
      deferred
      end

   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      require
         output.is_connected
      deferred
      end

end -- class MIXUP_LILYPOND_ITEM
