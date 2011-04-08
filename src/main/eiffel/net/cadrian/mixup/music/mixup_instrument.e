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
   set_voices (a_voices: like voices) is
      require
         a_voices /= Void
         voices = Void
      do
         voices := a_voices
      ensure
         voices = a_voices
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
         Result := voices.new_events_iterator(context)
         if not strophes.is_empty then
            create {MIXUP_EVENTS_ITERATOR_ON_INSTRUMENT} Result.make(Result, strophes)
         end
      end

   commit (a_player: MIXUP_PLAYER; start_bar_number: INTEGER) is
      do
         set_bar_number(voices.commit(Current, a_player, start_bar_number))
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
         Result := voices.bars
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
   make (a_source: like source; a_name: ABSTRACT_STRING; a_parent: like parent) is
      do
         context_make(a_source, a_name, a_parent)
         create {FAST_ARRAY[COLLECTION[FIXED_STRING]]} strophes.make(0)
      end

   strophes: COLLECTION[COLLECTION[FIXED_STRING]]
   current_strophe: COLLECTION[FIXED_STRING]
   voices: MIXUP_VOICES

invariant
   strophes /= Void

end -- class MIXUP_INSTRUMENT
