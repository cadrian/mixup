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
class MIXUP_INSTRUMENT

inherit
   MIXUP_CONTEXT
      rename
         make as context_make
      end

create {ANY}
   make

create {MIXUP_INSTRUMENT}
   duplicate

feature {ANY}
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE)
      do
         crash
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE
      do
         check Result = Void end
      end

   set_staves (a_staves: like staves)
      require
         a_staves /= Void
         staves = Void
      do
         staves := a_staves
         debug
            a_staves.do_all(agent (staff: MIXUP_STAFF)
                               do
                                  log.trace.put_line(once "Instrument " | name | once ": " | &staff)
                               end)
         end
      ensure
         staves = a_staves
      end

   next_strophe
      do
         create current_strophe.make(0)
         strophes.add_last(current_strophe)
      end

   add_syllable (a_source: MIXUP_SOURCE; a_syllable: ABSTRACT_STRING; in_word: BOOLEAN)
      require
         a_syllable /= Void
      local
         syllable: MIXUP_SYLLABLE
      do
         syllable.set(a_source, a_syllable.intern, in_word)
         current_strophe.add_last(syllable)
      ensure
         current_strophe.count = old current_strophe.count + 1
         current_strophe.last.syllable = a_syllable.intern
         current_strophe.last.in_word = in_word
      end

   add_extern_syllables (a_syllables: MIXUP_IDENTIFIER)
      do
         -- TODO
      end

   new_events_iterator: MIXUP_EVENTS_ITERATOR
      local
         context: MIXUP_EVENTS_ITERATOR_CONTEXT
      do
         context.set_instrument(Current)
         create {MIXUP_EVENTS_ITERATOR_ON_STAVES} Result.make(context, staves)
         if not strophes.is_empty then
            create {MIXUP_EVENTS_ITERATOR_ON_LYRICS} Result.make(Result, strophes)
         end
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      local
         staves_: FAST_ARRAY[MIXUP_STAFF]
         staves_zip: ZIP[MIXUP_STAFF, INTEGER]
      do
         a_commit_context.set_instrument(Current)
         create staves_.make(staves.count)
         create staves_zip.make(staves, staves_.lower |..| staves_.upper)
         staves_zip.do_all(agent (staff: MIXUP_STAFF; index: INTEGER; a_staves: FAST_ARRAY[MIXUP_STAFF]; commit_context_: MIXUP_COMMIT_CONTEXT)
                           local
                              staff_: MIXUP_STAFF
                           do
                              staff_ := staff.commit(commit_context_)
                              a_staves.put(staff_, index)
                           end(?, ?, staves_, a_commit_context))
         create Result.duplicate(source, name, parent, commit_values(a_commit_context), commit_imports(a_commit_context), staves_, strophes)
         -- TODO check timing durations
         Result.set_timing(staves_.first.timing)
      end

   accept (visitor: VISITOR)
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_instrument(Current)
      end

   voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]
      local
         ids: AVL_DICTIONARY[TRAVERSABLE[INTEGER], INTEGER]
      do
         create ids.make
         Result := ids
         staves.do_all(agent (a_staff: MIXUP_STAFF; a_ids: AVL_DICTIONARY[TRAVERSABLE[INTEGER], INTEGER])
                          do
                             a_ids.add(a_staff.voice_ids, a_staff.id)
                          end (?, ids))
      end

   relative_staff_id (a_staff_id: INTEGER): INTEGER
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            Result := 1
            i := staves.lower
         until
            found or else i > staves.upper
         loop
            if staves.item(i).id = a_staff_id then
               found := True
            else
               Result := Result + 1
            end
            i := i + 1
         end
      end

   valid_relative_staff_id (rel_staff_id: INTEGER): BOOLEAN
      do
         Result := staves.valid_index(rel_staff_id - 1 + staves.lower)
      end

   absolute_staff_id (rel_staff_id: INTEGER): INTEGER
      do
         Result := staves.item(rel_staff_id - 1 + staves.lower).id
      end

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT)
      do
         check
            {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_child
         end
         -- nothing to do
      end

feature {}
   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE
      do
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN
      do
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent)
      do
         create strophes.make(0)
         context_make(a_source, a_name, a_parent)

         if a_parent /= Void then
            a_parent.add_child(Current)
         end
      end

   duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_values: like values; a_imports: like imports; a_staves: like staves; a_strophes: like strophes)
      do
         source := a_source
         name := a_name
         parent := a_parent
         values := a_values
         imports := a_imports
         staves := a_staves
         strophes := a_strophes
         create resolver.make(Current)
      ensure
         source = a_source
         name = a_name
         parent = a_parent
         values = a_values
         staves = a_staves
         strophes = a_strophes
      end

   strophes: FAST_ARRAY[COLLECTION[MIXUP_SYLLABLE]]
   current_strophe: FAST_ARRAY[MIXUP_SYLLABLE]
   staves: COLLECTION[MIXUP_STAFF]

invariant
   strophes /= Void

end -- class MIXUP_INSTRUMENT
