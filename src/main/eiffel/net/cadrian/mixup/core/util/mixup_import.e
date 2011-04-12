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
class MIXUP_IMPORT

inherit
   MIXUP_CONTEXT
      rename
         make as make_context
      redefine
         add_to_parent
      end

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   commit (a_player: MIXUP_PLAYER; start_bar_number: INTEGER) is
      do
         child.commit(a_player, start_bar_number)
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_import(Current)
      end

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT) is
      do
         check
            never_called: False
         end
      end

feature {}
   valid_identifier (identifier: FIXED_STRING): BOOLEAN is
      require
         identifier /= Void
      do
         Result := identifier.has_prefix(name)
            and then identifier.count > name.count
            and then identifier.item(identifier.lower + name.count) = '.'
      end

   child_identifier (identifier: FIXED_STRING): FIXED_STRING is
      do
         Result := identifier.substring(name.count + 1, identifier.upper)
      end

   lookup_in_children (identifier: FIXED_STRING; cut: MIXUP_CONTEXT): MIXUP_EXPRESSION is
      do
         if child /= cut and then valid_identifier(identifier) then
            Result := child.lookup_expression(child_identifier(identifier), False, Current)
         end
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; cut: MIXUP_CONTEXT): BOOLEAN is
      do
         if child /= cut and then valid_identifier(identifier) then
            Result := child.setup_expression(child_identifier(identifier), True, a_value, Current)
         end
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent; child_context: like child) is
      require
         child_context /= Void
      do
         make_context(a_source, a_name, a_parent)
         child := child_context
      ensure
         child = child_context
      end

   child: MIXUP_CONTEXT

   add_to_parent (a_parent: MIXUP_CONTEXT) is
      do
         a_parent.add_import(Current)
      end

invariant
   child /= Void

end -- class MIXUP_IMPORT
