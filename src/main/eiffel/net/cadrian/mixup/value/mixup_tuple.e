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
class MIXUP_TUPLE

inherit
   MIXUP_ITERABLE
      redefine
         append_to
      end

create {ANY}
   make

create {MIXUP_TUPLE}
   duplicate

feature {ANY}
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_tuple(Current)
      end

   count: INTEGER
      do
         Result := expressions.count
      end

   is_empty: BOOLEAN
      do
         Result := expressions.is_empty
      end

   lower: INTEGER is 0

   upper: INTEGER
      do
         Result := expressions.count - 1
      end

   item (index: INTEGER): MIXUP_VALUE
      do
         if values /= Void then
            Result := values.item(index)
         end
      end

   first: MIXUP_VALUE
      do
         if values /= Void then
            Result := values.first
         end
      end

   last: MIXUP_VALUE
      do
         if values /= Void then
            Result := values.last
         end
      end

   new_iterator: ITERATOR[MIXUP_VALUE]
      do
         if values /= Void then
            Result := values.new_iterator
         end
      end

   append_to (a_values: COLLECTION[MIXUP_VALUE])
      do
         if values /= Void then
            a_values.append_traversable(values)
         end
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (buffer: STRING)
      local
         i: INTEGER
      do
         buffer.extend('[')
         from
            i := expressions.lower
         until
            i > expressions.upper
         loop
            if i > expressions.lower then
               buffer.append(once ", ")
            end
            expressions.item(i).as_name_in(buffer)
            i := i + 1
         end
         buffer.extend(']')
      end

feature {}
   make (a_source: like source; a_expressions: like expressions)
      require
         a_source /= Void
         a_expressions /= Void
      do
         source := a_source
         expressions := a_expressions
      ensure
         source = a_source
         expressions = a_expressions
      end

   duplicate (a_source: like source; a_values: like values)
      require
         a_source /= Void
         a_values /= Void
      do
         source := a_source
         expressions := a_values
         values := a_values
      ensure
         source = a_source
         values = a_values
      end

   expressions: TRAVERSABLE[MIXUP_EXPRESSION]
   values: FAST_ARRAY[MIXUP_VALUE]

   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      local
         i: INTEGER; a_values: like values
      do
         if values /= Void then
            Result := Current
         else
            create a_values.with_capacity(expressions.count)
            from
               i := expressions.lower
            until
               i > expressions.upper
            loop
               a_values.add_last(expressions.item(i).eval(a_commit_context, True))
               i := i + 1
            end
            create {MIXUP_TUPLE} Result.duplicate(source, a_values)
         end
      end

invariant
   expressions /= Void
   values /= Void implies values = expressions

end -- class MIXUP_TUPLE
