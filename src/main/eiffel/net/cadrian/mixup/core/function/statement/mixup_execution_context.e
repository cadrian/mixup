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
deferred class MIXUP_EXECUTION_CONTEXT

inherit
   MIXUP_VALUE_VISITOR

insert
   MIXUP_ERRORS

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER)
      local
         value: MIXUP_VALUE
      do
         value := context.resolver.resolve(a_identifier, commit_context)
         if value = Void then
            error("value could not be computed")
         else
            value.accept(Current)
         end
      end

feature {MIXUP_AGENT}
   visit_agent (a_agent: MIXUP_AGENT)
      local
         fun: MIXUP_AGENT_FUNCTION
         args: FAST_ARRAY[MIXUP_VALUE]
         i: INTEGER
      do
         if a_agent.args = Void then
            create args.make(0)
         else
            from
               create args.with_capacity(a_agent.args.count)
               i := a_agent.args.lower
            until
               i > a_agent.args.upper
            loop
               args.add_last(a_agent.args.item(i).eval(commit_context, True))
               i := i + 1
            end
         end
         create fun.make(a_agent.source, a_agent.expression.eval(commit_context, True), args)
         fun.accept(Current)
      end

feature {MIXUP_OPEN_ARGUMENT}
   visit_open_argument (a_open_argument: MIXUP_OPEN_ARGUMENT)
      do
         error("unexpected open argument")
      end

feature {MIXUP_RESULT}
   visit_result (a_result: MIXUP_RESULT)
      do
         sedb_breakpoint -- TODO
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION)
      do
         call_function(a_function)
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION)
      do
         call_function(a_function)
      end

feature {MIXUP_AGENT_FUNCTION}
   visit_agent_function (a_function: MIXUP_AGENT_FUNCTION)
      do
         call_function(a_function)
      end

feature {}
   call_function (a_function: MIXUP_FUNCTION)
      local
         value: MIXUP_VALUE
      do
         value := a_function.call(source, commit_context, create {FAST_ARRAY[MIXUP_VALUE]}.make(0))
         if value = Void then
            error("value could not be computed")
         else
            value.accept(Current)
         end
      end

   commit_context: MIXUP_COMMIT_CONTEXT

   context: MIXUP_USER_FUNCTION_CONTEXT
      do
         Result ::= commit_context.context
      end

invariant
   {MIXUP_USER_FUNCTION_CONTEXT} ?:= commit_context.context
   context /= Void

end -- class MIXUP_EXECUTION_CONTEXT
