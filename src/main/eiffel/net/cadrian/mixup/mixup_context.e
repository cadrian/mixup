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
deferred class MIXUP_CONTEXT

inherit
   VISITABLE

insert
   MIXUP_ERRORS

feature {ANY}
   name: FIXED_STRING
   resolver: MIXUP_RESOLVER
   bar_number: INTEGER

   set_bar_number (a_bar_number: like bar_number) is
      do
         bar_number := a_bar_number
         if parent /= Void then
            parent.set_bar_number(a_bar_number)
         end
      end

   commit (a_player: MIXUP_PLAYER; start_bar_number: INTEGER) is
      deferred
      end

   add_expression (a_name: FIXED_STRING; a_expression: MIXUP_EXPRESSION) is
      require
         a_name /= Void
         a_expression /= Void
      do
         if expressions.has(a_name) then
            warning("duplicate expression in the same context (ignored)")
         else
            debug
               log.trace.put_line("Adding '" + a_name + "' to {" + generating_type + "}." + name )
            end
            expressions.add(a_expression, a_name)
         end
      end

   hook (hook_name: ABSTRACT_STRING; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      local
         full_hook_name, debug_expressions: STRING
      do
         full_hook_name := once ""
         full_hook_name.clear_count
         full_hook_name.append(once "hook.")
         full_hook_name.append(hook_name)
         debug
            debug_expressions := expressions.out
         end
         Result := lookup(full_hook_name.intern, a_player, False)
      end

   lookup (identifier: FIXED_STRING; a_player: MIXUP_PLAYER; search_parent: BOOLEAN): MIXUP_VALUE is
      require
         identifier /= Void
         a_player /= Void
      local
         expression: MIXUP_EXPRESSION
      do
         expression := lookup_expression(identifier, search_parent, Void)
         if expression /= Void then
            Result := expression.eval(Current, a_player)
         end
         debug
            if Result = Void then
               log.trace.put_line("Look-up of '" + identifier + "' returned nothing.")
            else
               log.trace.put_line("Look-up of '" + identifier + "' returned " + Result.out)
            end
         end
      end

   setup (identifier: FIXED_STRING; a_player: MIXUP_PLAYER; a_value: MIXUP_VALUE) is
      require
         identifier /= Void
         a_player /= Void
         a_value /= Void
      local
         done: BOOLEAN
      do
         done := setup_expression(identifier, True, a_value, Void)
         if not done then
            fatal("could not assign value to " + identifier.out)
         end
      end

   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      require
         a_name /= Void
         a_value /= Void
      do
         crash -- unexpected
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE is
      do
      end

   run_hook (a_player: MIXUP_PLAYER; hook_name: STRING) is
      local
         h, res: MIXUP_VALUE
      do
         h := hook(hook_name, a_player)
         if h = Void then
            -- nothing to do
         elseif h.is_callable then
            res := h.call(a_player, create {FAST_ARRAY[MIXUP_VALUE]}.make(0))
            if res /= Void then
               warning("lost result")
            end
         else
            fatal("hook not callable")
         end
      end

feature {MIXUP_CONTEXT}
   lookup_expression (identifier: FIXED_STRING; search_parent: BOOLEAN; cut: MIXUP_CONTEXT): MIXUP_EXPRESSION is
      require
         identifier /= Void
      do
         Result := get_local(identifier)
         if Result = Void then
            Result := expressions.reference_at(identifier)
         end
         if Result = Void then
            Result := lookup_in_children(identifier, cut)
            if Result = Void then
               Result := lookup_in_imports(identifier, cut)
               if Result = Void and then search_parent and then parent /= Void then
                  Result := parent.lookup_expression(identifier, True, Current)
               end
            end
         end
      end

   setup_expression (identifier: FIXED_STRING; assign_if_new: BOOLEAN; a_value: MIXUP_VALUE; cut: MIXUP_CONTEXT): BOOLEAN is
      require
         identifier /= Void
         a_value /= Void
      local
         exp: MIXUP_EXPRESSION
      do
         exp := get_local(identifier)
         if exp /= Void then
            set_local(identifier, a_value)
            Result := True
         else
            exp := expressions.reference_at(identifier)
            if exp /= Void then
               set_local(identifier, a_value)
               Result := True
            else
               Result := setup_in_children(identifier, a_value, cut)
               if not Result then
                  Result := setup_in_imports(identifier, a_value, cut)
                  if not Result and then parent /= Void then
                     Result := parent.setup_expression(identifier, False, a_value, Current)
                  end
                  if not Result and then assign_if_new then
                     set_local(identifier, a_value)
                     Result := True
                  end
               end
            end
         end
      end

   add_child (a_child: MIXUP_CONTEXT) is
      require
         a_child /= Void
         not ({MIXUP_IMPORT} ?:= a_child)
      deferred
      end

   add_import (a_import: MIXUP_IMPORT) is
      require
         a_import /= Void
      do
         imports.add_last(a_import)
      end

feature {}
   expressions: DICTIONARY[MIXUP_EXPRESSION, FIXED_STRING]
   parent: MIXUP_CONTEXT
   imports: FAST_ARRAY[MIXUP_IMPORT]

   lookup_in_children (identifier: FIXED_STRING; cut: MIXUP_CONTEXT): MIXUP_EXPRESSION is
      require
         identifier /= Void
      deferred
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; cut: MIXUP_CONTEXT): BOOLEAN is
      require
         identifier /= Void
         a_value /= Void
      deferred
      end

   lookup_in_imports (identifier: FIXED_STRING; cut: MIXUP_CONTEXT): MIXUP_EXPRESSION is
      require
         identifier /= Void
      local
         i: INTEGER
      do
         from
            i := imports.lower
         until
            Result /= Void or else i > imports.upper
         loop
            Result := imports.item(i).lookup_expression(identifier, False, Current)
            i := i + 1
         end
      end

   setup_in_imports (identifier: FIXED_STRING; a_value: MIXUP_VALUE; cut: MIXUP_CONTEXT): BOOLEAN is
      require
         identifier /= Void
         a_value /= Void
      local
         i: INTEGER
      do
         from
            i := imports.lower
         until
            Result or else i > imports.upper
         loop
            Result := imports.item(i).setup_expression(identifier, False, a_value, Current)
            i := i + 1
         end
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         source := a_source
         name := a_name.intern
         parent := a_parent
         create {HASHED_DICTIONARY[MIXUP_EXPRESSION, FIXED_STRING]} expressions.make
         create imports.make(0)

         if a_parent /= Void then
            add_to_parent(a_parent)
         end

         create resolver.make(Current)
         bar_number := 1
      ensure
         source = a_source
         name = a_name.intern
         parent = a_parent
      end

   add_to_parent (a_parent: MIXUP_CONTEXT) is
      do
         a_parent.add_child(Current)
      end

invariant
   source /= Void
   name /= Void
   expressions /= Void
   resolver /= Void
   imports /= Void

end -- class MIXUP_CONTEXT
