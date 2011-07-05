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
class MIXUP_FROM_IMPORT

inherit
   MIXUP_IMPORT

create {ANY}
   make

create {MIXUP_FROM_IMPORT}
   duplicate

feature {ANY}
   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_from_import(Current)
      end

   commit (a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like Current is
      local
         timing_: MIXUP_MUSIC_TIMING
      do
         create Result.duplicate(source, name, parent, child.commit(a_player, a_start_bar_number), commit_values(a_player, a_start_bar_number), commit_imports(a_player, a_start_bar_number), identifiers)
         Result.set_timing(timing_.set(0, a_start_bar_number, 0))
      end

feature {}
   valid_identifier (identifier: FIXED_STRING): BOOLEAN is
      do
         if identifiers.is_empty then
            Result := True
         else
            Result := identifiers.exists(agent (a_id: MIXUP_IDENTIFIER; a_name: FIXED_STRING): BOOLEAN is
               do
                  Result := a_id.as_name.intern = a_name
               end (?, identifier))
         end
      end

   child_identifier (identifier: FIXED_STRING): FIXED_STRING is
      do
         Result := identifier
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent; child_context: like child; a_identifiers: like identifiers) is
      require
         child_context /= Void
         a_identifiers /= Void
         not ({MIXUP_IMPORT} ?:= child_context)
      do
         child := child_context
         make_context(a_source, a_name, a_parent)
         a_parent.add_import(Current)
         identifiers := a_identifiers
      ensure
         identifiers = a_identifiers
      end

   duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_child: like child; a_values: like values; a_imports: like imports; a_identifiers: like identifiers) is
      do
         source := a_source
         name := a_name
         parent := a_parent
         child := a_child
         values := a_values
         imports := a_imports
         identifiers := a_identifiers
         create resolver.make(Current)
      end

   identifiers: TRAVERSABLE[MIXUP_IDENTIFIER]

invariant
   identifiers /= Void

end -- class MIXUP_FROM_IMPORT
