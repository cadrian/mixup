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
class MIXUP_IF

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   condition: MIXUP_EXPRESSION
   statements: TRAVERSABLE[MIXUP_STATEMENT]

feature {}
   make (a_source: like source; a_condition: like condition; a_statements: like statements)
      require
         a_source /= Void
         a_condition /= Void
         a_statements /= Void
      do
         source := a_source
         condition := a_condition
         statements := a_statements
      ensure
         source = a_source
         condition = a_condition
         statements = a_statements
      end

invariant
   source /= Void
   condition /= Void
   statements /= Void

end -- class MIXUP_IF
