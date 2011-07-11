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
class MIXUP_MODULE

inherit
   MIXUP_CONTEXT

insert
   MIXUP_ERRORS

create {ANY}
   make

create {MIXUP_MODULE}
   duplicate

feature {ANY}
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      do
         crash
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE is
      do
         check Result = Void end
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current is
      local
         timing_: like timing
      do
         create Result.duplicate(source, name, parent, commit_values(a_commit_context), commit_imports(a_commit_context))
         Result.set_timing(timing_.set(0, a_commit_context.bar_number, 0))
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_module(Current)
      end

feature {}
   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE is
      do
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      do
      end

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT) is
      do
         check
            {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_child
         end
         -- nothing to do
      end

feature {}
   duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_values: like values; a_imports: like imports) is
      do
         source := a_source
         name := a_name
         parent := a_parent
         values := a_values
         imports := a_imports
         create resolver.make(Current)
      end

end -- class MIXUP_MODULE
