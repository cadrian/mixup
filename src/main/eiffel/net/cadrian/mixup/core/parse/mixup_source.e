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
deferred class MIXUP_SOURCE

insert
   ANY
      redefine out_in_tagged_out_memory
      end

feature {ANY}
   file: FIXED_STRING is
      deferred
      end

   line: INTEGER is
      deferred
      end

   column: INTEGER is
      deferred
      end

   display (a_output: OUTPUT_STREAM) is
      require
         a_output.is_connected
      deferred
      end

   out_in_tagged_out_memory is
      do
         file.out_in_tagged_out_memory
         tagged_out_memory.extend('@')
         line.append_in(tagged_out_memory)
         tagged_out_memory.extend(',')
         column.append_in(tagged_out_memory)
      end

end -- class MIXUP_SOURCE
