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

   commit (a_player: MIXUP_PLAYER) is
      require
         a_player /= Void
      do
         children.do_all(agent {MIXUP_CONTEXT}.commit(a_player))
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
         expression := lookup_expression(identifier, search_parent)
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
         done := setup_expression(identifier, True, a_value)
         if not done then
            fatal("could not assign value to " + identifier.out)
         end
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         accept_start(v)
         children.do_all_items(agent {MIXUP_CONTEXT}.accept(visitor))
         accept_end(v)
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

feature {MIXUP_CONTEXT}
   lookup_expression (identifier: FIXED_STRING; search_parent: BOOLEAN): MIXUP_EXPRESSION is
      require
         identifier /= Void
      local
         id_prefix: FIXED_STRING; i: INTEGER
         child: MIXUP_CONTEXT
      do
         Result := get_local(identifier)
         if Result = Void then
            Result := expressions.reference_at(identifier)
         end
         if Result = Void then
            i := identifier.first_index_of('.')
            if identifier.valid_index(i) then
               id_prefix := identifier.substring(identifier.lower, i - 1)
               child := children.reference_at(id_prefix)
               if child /= Void then
                  Result := child.lookup_expression(identifier.substring(i + 1, identifier.upper), False)
               end
            end
            if Result = Void and then search_parent and then parent /= Void then
               Result := parent.lookup_expression(identifier, True)
            end
         end
      end

   setup_expression (identifier: FIXED_STRING; assign_if_new: BOOLEAN; a_value: MIXUP_VALUE): BOOLEAN is
      require
         identifier /= Void
         a_value /= Void
      local
         id_prefix: FIXED_STRING; i: INTEGER
         child: MIXUP_CONTEXT
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
               i := identifier.first_index_of('.')
               if identifier.valid_index(i) then
                  id_prefix := identifier.substring(identifier.lower, i - 1)
                  child := children.reference_at(id_prefix)
                  if child /= Void then
                     Result := child.setup_expression(identifier.substring(i + 1, identifier.upper), True, a_value)
                  end
               end
               if not Result and then parent /= Void then
                  Result := parent.setup_expression(identifier, False, a_value)
               end
               if not Result and then assign_if_new then
                  set_local(identifier, a_value)
                  Result := True
               end
            end
         end
      end

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR) is
      deferred
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR) is
      deferred
      end

feature {MIXUP_CONTEXT}
   add_child (a_context: MIXUP_CONTEXT) is
      require
         a_context /= Void
      do
         children.put(a_context, a_context.name)
      end

feature {}
   expressions: DICTIONARY[MIXUP_EXPRESSION, FIXED_STRING]
   children: DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]
   parent: MIXUP_CONTEXT

   make (a_name: ABSTRACT_STRING; a_parent: like parent) is
      require
         a_name /= Void
      do
         name := a_name.intern
         parent := a_parent
         create {HASHED_DICTIONARY[MIXUP_EXPRESSION, FIXED_STRING]} expressions.make
         create {LINKED_HASHED_DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]} children.make

         if a_parent /= Void then
            a_parent.add_child(Current)
         end

         create resolver.make(Current)
      ensure
         name = a_name.intern
         parent = a_parent
      end

invariant
   name /= Void
   expressions /= Void
   children /= Void
   resolver /= Void

end -- class MIXUP_CONTEXT
