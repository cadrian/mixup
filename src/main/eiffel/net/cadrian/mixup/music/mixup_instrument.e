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

feature {ANY}
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      do
         crash
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE is
      do
         check Result = Void end
      end

   set_staves (a_staves: like staves) is
      require
         a_staves /= Void
         staves = Void
      do
         staves := a_staves
         debug
            a_staves.do_all(agent (staff: MIXUP_STAFF) is
                               do
                                  log.trace.put_line("Instrument " + name.out + ": " + staff.out)
                               end)
         end
      ensure
         staves = a_staves
      end

   next_strophe is
      do
         create {FAST_ARRAY[FIXED_STRING]} current_strophe.make(0)
         strophes.add_last(current_strophe)
      end

   add_syllable (a_syllable: ABSTRACT_STRING) is
      require
         a_syllable /= Void
      do
         current_strophe.add_last(a_syllable.intern)
      ensure
         current_strophe.count = old current_strophe.count + 1
         current_strophe.last = a_syllable.intern
      end

   add_extern_syllables (a_syllables: MIXUP_IDENTIFIER) is
      do
         -- TODO
      end

   new_events_iterator: MIXUP_EVENTS_ITERATOR is
      local
         context: MIXUP_EVENTS_ITERATOR_CONTEXT
      do
         context.set_instrument(Current)
         create {MIXUP_EVENTS_ITERATOR_ON_STAVES} Result.make(context, staves)
         if not strophes.is_empty then
            create {MIXUP_EVENTS_ITERATOR_ON_LYRICS} Result.make(Result, strophes)
         end
      end

   commit (a_player: MIXUP_PLAYER; start_bar_number: INTEGER) is
      local
         bar_numbers: AGGREGATOR[MIXUP_STAFF, INTEGER]
         a_bar_number: INTEGER
      do
         a_bar_number := bar_numbers.map(staves,
                                         agent (staff: MIXUP_STAFF; a_bar_number, start_bar_number: INTEGER; a_player: MIXUP_PLAYER): INTEGER is
                                            do
                                               Result := staff.commit(Current, a_player, start_bar_number)
                                               if a_bar_number /= start_bar_number and then a_bar_number /= Result then
                                                  fatal_at(staff.source, "Differing bar numbers (" + a_bar_number.out + " ≠ " + start_bar_number.out + ")")
                                               end
                                            end(?, ?, start_bar_number, a_player),
                                         start_bar_number)
         set_bar_number(a_bar_number)
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_instrument(Current)
      end

   bars: ITERABLE[INTEGER_64] is
      do
         Result := staves.first.bars
      end

   staff_ids: TRAVERSABLE[INTEGER] is
      local
         ids: AVL_SET[INTEGER]
      do
         create ids.make
         Result := ids
         staves.do_all(agent (a_staff: MIXUP_STAFF; a_ids: SET[INTEGER]) is
                          do
                             a_ids.add(a_staff.id)
                          end (?, ids))
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
   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE is
      do
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      do
      end

feature {}
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         create {FAST_ARRAY[COLLECTION[FIXED_STRING]]} strophes.make(0)
         context_make(a_source, a_name, a_parent)

         if a_parent /= Void then
            a_parent.add_child(Current)
         end
      end

   strophes: COLLECTION[COLLECTION[FIXED_STRING]]
   current_strophe: COLLECTION[FIXED_STRING]
   staves: COLLECTION[MIXUP_STAFF]

invariant
   strophes /= Void

end -- class MIXUP_INSTRUMENT
