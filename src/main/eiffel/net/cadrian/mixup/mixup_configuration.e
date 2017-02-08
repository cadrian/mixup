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
expanded class MIXUP_CONFIGURATION
   --
   -- The program configuration.
   --

feature {ANY}
   lilypond_exe_path: REFERENCE[FIXED_STRING]
      once
         create Result.set_item("lilypond".intern)
      end

   lilypond_include_directories: FAST_ARRAY[FIXED_STRING]
      once
         create Result.with_capacity(4)
      end

end -- class MIXUP_CONFIGURATION
