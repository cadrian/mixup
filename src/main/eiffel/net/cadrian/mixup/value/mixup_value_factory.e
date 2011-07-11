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
class MIXUP_VALUE_FACTORY

inherit
   MIXUP_VALUE
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_value_factory(Current)
      end

   out_in_tagged_out_memory is
      do
         as_name_in(tagged_out_memory)
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(once "<value factory>")
      end

feature {}
   make (a_source: like source; a_factory: like factory) is
      require
         a_source /= Void
      do
         source := a_source
         factory := a_factory
      ensure
         source = a_source
         factory = a_factory
      end

   factory: FUNCTION[TUPLE[MIXUP_SOURCE, MIXUP_COMMIT_CONTEXT], MIXUP_VALUE]

   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE is
      do
         Result := factory.item([source, a_commit_context])
      end

   no_args: FAST_ARRAY[MIXUP_VALUE] is
      once
         create Result.make(0)
      end

invariant
   factory /= Void

end -- class MIXUP_VALUE_FACTORY
