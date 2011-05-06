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
class AUX_MIXUP_MOCK_CONTEXT

inherit
   MIXUP_CONTEXT

create {ANY}
   make

feature {ANY}
   commit (a_player: MIXUP_PLAYER; start_bar_number: INTEGER) is
      do
      end

   add_child (a_child: MIXUP_CONTEXT) is
      do
      end

   accept (a_visitor: VISITOR) is
      do
      end

feature {}
   lookup_in_children (identifier: FIXED_STRING; cut: MIXUP_CONTEXT): MIXUP_EXPRESSION is
      do
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; cut: MIXUP_CONTEXT): BOOLEAN is
      do
      end

end -- class AUX_MIXUP_MOCK_CONTEXT
