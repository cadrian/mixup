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
   is_callable: BOOLEAN is False

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

   first: MIXUP_VALUE is
      do
         Result := item(lower)
      end

   last: MIXUP_VALUE is
      do
         Result := item(upper)
      end

   count: INTEGER is
      do
         Result := upper - lower + 1
      end

   is_empty: BOOLEAN is
      do
         Result := count = 0
      end

   new_iterator: ITERATOR[MIXUP_VALUE] is
      do
         crash
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

   eval_ (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN; bar_number: INTEGER): MIXUP_VALUE is
      do
         Result := Current
      end

   error_message: STRING is "integer too big, only 32-bit supported in sequences (is your score that big?)"

end -- class MIXUP_SEQ
