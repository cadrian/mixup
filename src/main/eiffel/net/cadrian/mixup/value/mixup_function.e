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
deferred class MIXUP_FUNCTION

inherit
   MIXUP_VALUE
      undefine
         call
      end

feature {ANY}
   is_callable: BOOLEAN is True

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   frozen as_name_in (a_name: STRING)
      do
         a_name.append(once "<function>")
      end

feature {}
   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      do
         Result := Current
      end

end -- class MIXUP_FUNCTION
