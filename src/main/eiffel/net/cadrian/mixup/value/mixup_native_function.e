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
class MIXUP_NATIVE_FUNCTION

inherit
   MIXUP_FUNCTION
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING

   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_native_function(Current)
      end

   call (a_source: MIXUP_SOURCE; a_commit_context: MIXUP_COMMIT_CONTEXT; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE
      local
         native_context: MIXUP_NATIVE_CONTEXT
      do
         native_context.prepare(a_source, a_commit_context, a_args)
         Result := native_caller.item([native_context])
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "<native:")
         name.out_in_tagged_out_memory
         tagged_out_memory.extend('>')
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_context: like context; a_native_caller: like native_caller)
      require
         a_source /= Void
         a_name /= Void
         a_context /= Void
         a_native_caller /= Void
      do
         source := a_source
         name := a_name.intern
         context := a_context
         native_caller := a_native_caller
      ensure
         source = a_source
         name = a_name.intern
         context = a_context
         native_caller = a_native_caller
      end

   context: MIXUP_CONTEXT
   native_caller: FUNCTION[TUPLE[MIXUP_NATIVE_CONTEXT], MIXUP_VALUE]

invariant
   name /= Void
   context /= Void
   native_caller /= Void

end -- class MIXUP_NATIVE_FUNCTION
