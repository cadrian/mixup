deferred class MIXUP_CONTEXT

inherit
   VISITABLE

feature {ANY}
   name: FIXED_STRING

   lookup (identifier: FIXED_STRING): MIXUP_VALUE is
      require
         identifier /= Void
      local
         id_prefix: FIXED_STRING; i: INTEGER
         child: MIXUP_CONTEXT
      do
         Result := values.reference_at(identifier)
         if Result = Void then
            i := identifier.first_index_of('.')
            if identifier.valid_index(i) then
               id_prefix := identifier.substring(identifier.lower, i - 1)
               child := children.reference_at(id_prefix)
               if child /= Void then
                  Result := child.lookup(identifier.substring(i + 1, identifier.upper))
               end
            end
            if Result = Void and then parent /= Void then
               Result := parent.lookup(identifier)
            end
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
   values: DICTIONARY[MIXUP_VALUE, FIXED_STRING]
   children: DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]
   parent: MIXUP_CONTEXT

   make (a_name: ABSTRACT_STRING; a_parent: like parent) is
      require
         a_name /= Void
      do
         name := a_name.intern
         parent := a_parent
         create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} values.make
         create {LINKED_HASHED_DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]} children.make

         if a_parent /= Void then
            a_parent.add_child(Current)
         end
      ensure
         name = a_name.intern
         parent = a_parent
      end

invariant
   name /= Void
   values /= Void
   children /= Void

end
