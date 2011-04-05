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
   warning (message: ABSTRACT_STRING) is
      require
         message /= Void
      do
         log.warning.put_line(header + message)
         warning_count.increment
      end

   error (message: ABSTRACT_STRING) is
      require
         message /= Void
      do
         log.error.put_line(header + message)
         error_count.increment
      end

   fatal (message: ABSTRACT_STRING) is
      require
         message /= Void
      do
         log.error.put_line(header + message)
         error_count.increment
         display_counter(warning_count.value, "warning")
         display_counter(error_count.value, "error")
         die_with_code(1)
      end

feature {}
   display_counter (count: INTEGER; tag: STRING) is
      do
         log.error.put_string(header + count.out)
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

   header: STRING is "**** "

end -- class MIXUP_ERRORS
