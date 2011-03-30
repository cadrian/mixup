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
class MIXUP_LOOP

inherit
   MIXUP_STATEMENT

create {ANY}
   make

feature {ANY}
   identifier: FIXED_STRING
   expression: MIXUP_EXPRESSION
   statements: TRAVERSABLE[MIXUP_STATEMENT]

   call (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; args: MAP[MIXUP_VALUE, FIXED_STRING]) is
      do
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_STATEMENT_VISITOR
      do
         v ::= visitor
         v.visit_loop(Current)
      end

feature {}
   make (a_identifier: like identifier; a_expression: like expression; a_statements: like statements) is
      require
         a_identifier /= Void
         a_expression /= Void
         a_statements /= Void
      do
         identifier := a_identifier
         expression := a_expression
         statements := a_statements
      ensure
         identifier = a_identifier
         expression = a_expression
         statements = a_statements
      end

invariant
   identifier /= Void
   expression /= Void
   statements /= Void

end -- class MIXUP_LOOP
