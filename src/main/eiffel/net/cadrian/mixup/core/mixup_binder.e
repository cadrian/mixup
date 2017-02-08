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

feature {ANY}
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE)
      do
         crash
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE
      do
         check Result = Void end
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      require
         a_commit_context.player /= Void
      local
         children_: like children
         children_zip: MAP_AGGREGATOR[MIXUP_CONTEXT, FIXED_STRING, MIXUP_MUSIC_TIMING]
         timing_: MIXUP_MUSIC_TIMING
      do
         create children_.with_capacity(children.count)
         a_commit_context.set_context(Current)
         timing_ := children_zip.map(children,
                                     agent (a_children: like children; commit_context_: MIXUP_COMMIT_CONTEXT; a_child: MIXUP_CONTEXT; a_key: FIXED_STRING; a_timing: MIXUP_MUSIC_TIMING): MIXUP_MUSIC_TIMING
                                     local
                                        child_: MIXUP_CONTEXT
                                     do
                                        commit_context_.set_bar_number(a_timing.first_bar_number + a_timing.bars_count)
                                        child_ := a_child.commit(commit_context_)
                                        a_children.add(child_, a_key)
                                        Result := a_timing + child_.timing
                                     end(children_, a_commit_context, ?, ?, ?),
                                     timing_.set(0, a_commit_context.bar_number, 0))
         Result := do_duplicate(source, name, parent, commit_values(a_commit_context), commit_imports(a_commit_context), children_)
         Result.set_timing(timing_)
      end

   accept (visitor: VISITOR)
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         accept_start(v)
         children.do_all_items(agent {MIXUP_CONTEXT}.accept(visitor))
         accept_end(v)
      end

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT)
      do
         children.add(a_child, a_child.name)
      end

feature {}
   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE
      local
         id_prefix: FIXED_STRING; i: INTEGER
         child: MIXUP_CONTEXT
      do
         i := identifier.first_index_of('.')
         if identifier.valid_index(i) then
            id_prefix := identifier.substring(identifier.lower, i - 1)
            child := children.reference_at(id_prefix)
            if child /= Void and then child.lookup_tag < lookup_tag then
               Result := child.lookup_value(identifier.substring(i + 1, identifier.upper), False, lookup_tag)
            end
         end
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN
      local
         id_prefix: FIXED_STRING; i: INTEGER
         child: MIXUP_CONTEXT
      do
         i := identifier.first_index_of('.')
         if identifier.valid_index(i) then
            id_prefix := identifier.substring(identifier.lower, i - 1)
            child := children.reference_at(id_prefix)
            if child /= Void and then child.lookup_tag < lookup_tag then
               Result := child.setup_value(identifier.substring(i + 1, identifier.upper), True, a_value, is_const, is_public, is_local, lookup_tag)
            end
         end
      end

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR)
      deferred
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR)
      deferred
      end

feature {}
   children: LINKED_HASHED_DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]

   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent)
      do
         create children.make
         context_make(a_source, a_name, a_parent)

         if a_parent /= Void then
            a_parent.add_child(Current)
         end
      end

   do_duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_values: like values; a_imports: like imports; a_children: like children): like Current
      deferred
      ensure
         Result /= Void
         Result /= Current
         Result.source = a_source
         Result.name = a_name.intern
         --Result.parent = a_parent
         --Result.children = a_children
      end

   duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_values: like values; a_imports: like imports; a_children: like children)
      do
         source := a_source
         name := a_name
         parent := a_parent
         values := a_values
         imports := a_imports
         children := a_children
         create resolver.make(Current)
      end

invariant
   children /= Void

end -- class MIXUP_BINDER
