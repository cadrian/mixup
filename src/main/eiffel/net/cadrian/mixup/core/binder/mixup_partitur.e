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
class MIXUP_PARTITUR

inherit
   MIXUP_BINDER

create {ANY}
   make

create {MIXUP_PARTITUR}
   duplicate

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR)
      do
         visitor.start_partitur(Current)
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR)
      do
         visitor.end_partitur(Current)
      end

   do_duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_values: like values; a_imports: like imports; a_children: like children): like Current
      do
         create Result.duplicate(a_source, a_name, a_parent, a_values, a_imports, a_children)
      end

end -- class MIXUP_PARTITUR
