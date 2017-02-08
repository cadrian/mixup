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
class MIXUP_AGENT_FUNCTION

inherit
   MIXUP_FUNCTION
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_agent_function(Current)
      end

   call (a_source: MIXUP_SOURCE; a_commit_context: MIXUP_COMMIT_CONTEXT; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE
      local
         merger: MIXUP_ARGUMENTS_MERGER
      do
         create merger.make(a_source, args)
         Result := value.call(a_source, a_commit_context, merger.merge(a_args))
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(once "<agent function>")
      end

feature {}
   make (a_source: like source; a_value: like value; a_args: like args)
      require
         a_source /= Void
         a_value /= Void
         a_args /= Void
         a_value.is_callable
      do
         source := a_source
         value := a_value
         args := a_args
      ensure
         source = a_source
         value = a_value
         args = a_args
      end

   value: MIXUP_VALUE
   args: TRAVERSABLE[MIXUP_VALUE]

invariant
   value /= Void
   args /= Void
   value.is_callable

end -- class MIXUP_AGENT_FUNCTION
