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
class MIXUP_LINE_NUMBER_OUTPUT

inherit
   FILTER_OUTPUT_STREAM
      redefine
         can_put_character
      end

create {ANY}
   bind

feature {ANY}
   can_put_character (c: CHARACTER): BOOLEAN
      do
         Result := is_connected
            and then (c = '%N'
                      or else not current_line.in_range(line - delta, line)
                      or else stream.can_put_character(c))
      end

   blanks: STRING

feature {FILTER_OUTPUT_STREAM}
   filtered_put_character (c: CHARACTER)
      do
         if current_line.in_range(line - delta + 1, line) then
            stream.filtered_put_character(c)
            if current_line = line then
               inspect c
               when '%T' then
                  blanks.extend('%T')
               when '%N' then
               else
                  blanks.extend(' ')
               end
            end
         end
         if c = '%N' then
            current_line := current_line + 1
         end
      end

   filtered_flush
      do
         stream.filtered_flush
      end

feature {}
   bind (a_stream: like stream; a_line: like line; a_delta: like delta)
      require
         a_stream.is_connected
         a_line > 0
         a_delta > 0
      do
         connect_to(a_stream)
         line := a_line
         delta := a_delta
         current_line := 1
         blanks := ""
      ensure
         stream = a_stream
         line = a_line
         delta = a_delta
      end

   line: INTEGER
   delta: INTEGER
   current_line: INTEGER

   local_can_disconnect: BOOLEAN is True

invariant
   line > 0
   delta > 0

end -- class MIXUP_LINE_NUMBER_OUTPUT
