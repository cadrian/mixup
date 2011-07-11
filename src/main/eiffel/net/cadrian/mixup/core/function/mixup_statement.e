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
deferred class MIXUP_STATEMENT

inherit
   VISITABLE

insert
   MIXUP_ERRORS

feature {ANY}
   call (a_commit_context: MIXUP_COMMIT_CONTEXT) is
      require
         a_commit_context.context /= Void
         {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_commit_context.context
      deferred
      end

end -- class MIXUP_STATEMENT
