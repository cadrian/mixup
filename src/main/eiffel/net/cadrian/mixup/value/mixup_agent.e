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
class MIXUP_AGENT

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   expression: MIXUP_EXPRESSION
   args: TRAVERSABLE[MIXUP_EXPRESSION]

   is_callable: BOOLEAN is False

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_agent(Current)
      end

   set_args (a_args: like args) is
      do
         args := a_args
      ensure
         args = a_args
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.extend('%'')
         expression.as_name_in(a_name)
         if args /= Void then
            a_name.extend('(')
            args.do_all(agent (arg: MIXUP_EXPRESSION; nam: STRING) is do arg.as_name_in(nam) end(?, a_name))
            a_name.extend(')')
         end
      end

feature {}
   make (a_source: like source; a_expression: like expression) is
      require
         a_source /= Void
         a_expression /= Void
      do
         source := a_source
         expression := a_expression
      ensure
         source = a_source
         expression = a_expression
      end

   eval_ (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN; bar_number: INTEGER): MIXUP_VALUE is
      do
         Result := Current
      end

invariant
   expression /= Void

end -- class MIXUP_AGENT
