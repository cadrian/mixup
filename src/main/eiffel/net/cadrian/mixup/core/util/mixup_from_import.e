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
      rename
         make as make_import
      redefine
         valid_identifier, child_identifier, accept
      end

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_from_import(Current)
      end

feature {}
   valid_identifier (identifier: FIXED_STRING): BOOLEAN is
      do
         if identifier.is_empty then
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
      do
         identifiers := a_identifiers
         make_import(a_source, a_name, a_parent, child_context)
      ensure
         identifiers = a_identifiers
      end

   identifiers: TRAVERSABLE[MIXUP_IDENTIFIER]

invariant
   identifiers /= Void

end -- class MIXUP_FROM_IMPORT
