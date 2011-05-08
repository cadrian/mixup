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
      end

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
         Result := identifier.substring(name.count + 1 + identifier.lower, identifier.upper)
      end

   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE is
      do
         if child.lookup_tag /= lookup_tag and then valid_identifier(identifier) then
            Result := child.lookup_value(child_identifier(identifier), False, lookup_tag)
         end
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      do
         if child.lookup_tag /= lookup_tag and then valid_identifier(identifier) then
            Result := child.setup_value(child_identifier(identifier), True, a_value, is_const, is_public, is_local, lookup_tag)
         end
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent; child_context: like child) is
      require
         child_context /= Void
         a_parent /= Void
         not ({MIXUP_IMPORT} ?:= child_context)
      do
         child := child_context
         make_context(a_source, a_name, a_parent)

         a_parent.add_import(Current)
      ensure
         child = child_context
      end

   child: MIXUP_CONTEXT

invariant
   child /= Void
   not ({MIXUP_IMPORT} ?:= child)

end -- class MIXUP_IMPORT
