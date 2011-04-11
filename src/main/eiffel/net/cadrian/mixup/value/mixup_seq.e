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
class MIXUP_SEQ

inherit
   MIXUP_ITERABLE

create {ANY}
   make

feature {ANY}
   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_seq(Current)
      end

   lower: INTEGER
   upper: INTEGER

   item (index: INTEGER): MIXUP_VALUE is
      do
         create {MIXUP_INTEGER} Result.make(source, index)
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (buffer: STRING) is
      do
         buffer.append(once "seq(")
         lower.append_in(buffer)
         buffer.append(once ", ")
         upper.append_in(buffer)
         buffer.extend(')')
      end

feature {}
   make (a_source: like source; low, up: MIXUP_INTEGER) is
      require
         a_source /= Void
      do
         if not low.value.fit_integer_32 then
            fatal_at(low.source, error_message)
         elseif not up.value.fit_integer_32 then
            fatal_at(up.source, error_message)
         else
            source := a_source
            lower := low.value.to_integer_32
            upper := up.value.to_integer_32
         end
      ensure
         source = a_source
      end

   error_message: STRING is "integer too big, only 32-bit supported in sequences (is your score that big?)"

end -- class MIXUP_SEQ