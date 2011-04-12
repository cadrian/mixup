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
deferred class MIXUP_BINDER

inherit
   MIXUP_CONTEXT
      rename
         make as context_make
      end

insert
   MIXUP_ERRORS

feature {ANY}
   commit (a_player: MIXUP_PLAYER; start_bar_number: INTEGER) is
      require
         a_player /= Void
      local
         bar_counter: AGGREGATOR[MIXUP_CONTEXT, INTEGER]
      do
         set_bar_number(bar_counter.map(children, agent commit_child(?, a_player, start_bar_number, ?), start_bar_number))
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

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT) is
      do
         children.put(a_child, a_child.name)
      end

feature {}
   commit_child (a_child: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; start_bar_number, max_bar_number: INTEGER): INTEGER is
      do
         a_child.commit(a_player, start_bar_number)
         Result := a_child.bar_number.max(max_bar_number)
      end

   lookup_in_children (identifier: FIXED_STRING; cut: MIXUP_CONTEXT): MIXUP_EXPRESSION is
      local
         id_prefix: FIXED_STRING; i: INTEGER
         child: MIXUP_CONTEXT
      do
         i := identifier.first_index_of('.')
         if identifier.valid_index(i) then
            id_prefix := identifier.substring(identifier.lower, i - 1)
            child := children.reference_at(id_prefix)
            if child /= Void and then child /= cut then
               Result := child.lookup_expression(identifier.substring(i + 1, identifier.upper), False, Current)
            end
         end
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; cut: MIXUP_CONTEXT): BOOLEAN is
      local
         id_prefix: FIXED_STRING; i: INTEGER
         child: MIXUP_CONTEXT
      do
         i := identifier.first_index_of('.')
         if identifier.valid_index(i) then
            id_prefix := identifier.substring(identifier.lower, i - 1)
            child := children.reference_at(id_prefix)
            if child /= Void and then child /= cut then
               Result := child.setup_expression(identifier.substring(i + 1, identifier.upper), True, a_value, Current)
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

feature {}
   children: DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]

   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         context_make(a_source, a_name, a_parent)
         create {LINKED_HASHED_DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]} children.make
      end

invariant
   children /= Void

end -- class MIXUP_BINDER
