-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_INSTRUMENT

inherit
   MIXUP_CONTEXT
      rename
         make as context_make
      redefine
         commit
      end

insert
   LOGGING

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

   commit (a_player: MIXUP_PLAYER) is
      do
         debug
            log.trace.put_line("Committing instrument " + name)
         end
         voices.commit(Current, a_player)
      end

   bars: TRAVERSABLE[INTEGER_64] is
      do
         Result := voices.bars
      end

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.start_instrument(Current)
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.end_instrument(Current)
      end

feature {}
   make (a_name: ABSTRACT_STRING; a_parent: like parent; a_reference: MIXUP_NOTE_HEAD) is
      do
         context_make(a_name, a_parent)
         create {FAST_ARRAY[COLLECTION[FIXED_STRING]]} strophes.make(0)
      end

   strophes: COLLECTION[COLLECTION[FIXED_STRING]]
   current_strophe: COLLECTION[FIXED_STRING]
   voices: MIXUP_VOICES

invariant
   strophes /= Void

end -- class MIXUP_INSTRUMENT
