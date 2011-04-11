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
expanded class MIXUP_ERRORS

insert
   LOGGING

feature {ANY}
   source: MIXUP_SOURCE

   warning (message: ABSTRACT_STRING) is
      require
         message /= Void
         source /= Void
      do
         warning_at(source, message)
      end

   error (message: ABSTRACT_STRING) is
      require
         message /= Void
         source /= Void
      do
         error_at(source, message)
      end

   fatal (message: ABSTRACT_STRING) is
      require
         message /= Void
         source /= Void
      do
         fatal_at(source, message)
      end

feature {ANY}
   warning_at (a_source: like source; message: ABSTRACT_STRING) is
      require
         message /= Void
         a_source /= Void
      do
         log.warning.put_line(header(a_source) + message)
         a_source.display(log.warning)
         warning_count.increment
         sedb_breakpoint
      end

   error_at (a_source: like source; message: ABSTRACT_STRING) is
      require
         message /= Void
         a_source /= Void
      do
         log.error.put_line(header(a_source) + message)
         a_source.display(log.error)
         error_count.increment
         sedb_breakpoint
      end

   fatal_at (a_source: like source; message: ABSTRACT_STRING) is
      require
         message /= Void
         a_source /= Void
      do
         error_at(a_source, message)
         display_counter(a_source, warning_count.value, "warning")
         display_counter(a_source, error_count.value, "error")
         log.error.put_line("**** Program interrupted.")
         die_with_code(1)
      end

feature {}
   display_counter (a_source: like source; count: INTEGER; tag: STRING) is
      do
         log.error.put_string(header(a_source) + count.out)
         if count = 1 then
            log.error.put_line(" " + tag)
         else
            log.error.put_line(" " + tag + "s")
         end
      end

   warning_count: COUNTER is
      once
         create Result
      end

   error_count: COUNTER is
      once
         create Result
      end

   header (a_source: like source): STRING is
      do
         Result := "**** "
         Result.append(source.file)
         Result.append(once " line ")
         source.line.append_in(Result)
         Result.append(once ", column ")
         source.column.append_in(Result)
         Result.append(once ": ")
      end

end -- class MIXUP_ERRORS