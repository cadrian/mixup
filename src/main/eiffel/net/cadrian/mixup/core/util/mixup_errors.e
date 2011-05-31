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
         log.warning.put_line(error_header(a_source) + message)
         a_source.display(log.warning)
         warning_count.next
         sedb_breakpoint
      end

   error_at (a_source: like source; message: ABSTRACT_STRING) is
      require
         message /= Void
         a_source /= Void
      do
         log.error.put_line(error_header(a_source) + message)
         a_source.display(log.error)
         error_count.next
         sedb_breakpoint
      end

   fatal_at (a_source: like source; message: ABSTRACT_STRING) is
      require
         message /= Void
         a_source /= Void
      do
         error_at(a_source, message)
         display_counter(warning_count.item, "warning")
         display_counter(error_count.item, "error")
         log.error.put_line("Program interrupted.")
         die_with_code(1)
      end

feature {}
   display_counter (count: INTEGER; tag: STRING) is
      do
         if count > 0 then
            log.error.put_string(error_header(Void) + count.out)
            if count = 1 then
               log.error.put_line(" " + tag)
            else
               log.error.put_line(" " + tag + "s")
            end
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

   error_header (a_source: like source): STRING is
      do
         Result := ""
         if a_source /= Void then
            Result.append(a_source.file)
            Result.append(once " line ")
            a_source.line.append_in(Result)
            Result.append(once ", column ")
            a_source.column.append_in(Result)
            Result.append(once ": ")
         end
      end

end -- class MIXUP_ERRORS
