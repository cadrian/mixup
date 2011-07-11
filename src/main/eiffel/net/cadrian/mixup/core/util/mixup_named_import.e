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
class MIXUP_NAMED_IMPORT

inherit
   MIXUP_IMPORT

create {ANY}
   make

create {MIXUP_IMPORT}
   duplicate

feature {ANY}
   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current is
      local
         timing_: MIXUP_MUSIC_TIMING
      do
         a_commit_context.set_context(Current)
         create Result.duplicate(source, name, parent, child.commit(a_commit_context), commit_values(a_commit_context), commit_imports(a_commit_context))
         Result.set_timing(timing_.set(0, a_commit_context.bar_number, 0))
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_named_import(Current)
      end

feature {}
   valid_identifier (identifier: FIXED_STRING): BOOLEAN is
      do
         Result := identifier.has_prefix(name)
            and then identifier.count > name.count
            and then identifier.item(identifier.lower + name.count) = '.'
      end

   child_identifier (identifier: FIXED_STRING): FIXED_STRING is
      do
         Result := identifier.substring(name.count + 1 + identifier.lower, identifier.upper)
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

   duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_child: like child; a_values: like values; a_imports: like imports) is
      do
         source := a_source
         name := a_name
         parent := a_parent
         child := a_child
         values := a_values
         imports := a_imports
         create resolver.make(Current)
      end

end -- class MIXUP_NAMED_IMPORT
