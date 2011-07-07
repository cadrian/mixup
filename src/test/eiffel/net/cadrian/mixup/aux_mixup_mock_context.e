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
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      do
         crash
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE is
      do
         check Result = Void end
      end

   commit (a_player: MIXUP_PLAYER; start_bar_number: INTEGER): like Current is
      do
         Result := Current
         set_timing(timing.set(0, start_bar_number, 0))
      end

   add_child (a_child: MIXUP_CONTEXT) is
      do
      end

   accept (a_visitor: VISITOR) is
      do
      end

feature {}
   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE is
      do
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      do
      end

end -- class AUX_MIXUP_MOCK_CONTEXT
