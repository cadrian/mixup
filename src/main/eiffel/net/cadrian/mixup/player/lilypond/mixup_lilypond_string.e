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
class MIXUP_LILYPOND_STRING

inherit
   MIXUP_LILYPOND_ITEM

create {ANY}
   make

feature {ANY}
   string: FIXED_STRING

   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      do
         output.put_string(string)
      end

feature {}
   make (a_string: ABSTRACT_STRING) is
      require
         a_string /= Void
      do
         string := a_string.intern
      ensure
         string = a_string.intern
      end

invariant
   string /= Void

end -- class MIXUP_LILYPOND_STRING