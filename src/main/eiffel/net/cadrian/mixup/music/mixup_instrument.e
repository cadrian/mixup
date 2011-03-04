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

   new_note_iterator: MIXUP_NOTES_ITERATOR is
      local
         context: MIXUP_NOTES_ITERATOR_CONTEXT
      do
         context.set_instrument(Current)
         Result := voices.new_note_iterator(context)
         if not strophes.is_empty then
            create {MIXUP_NOTES_ITERATOR_ON_INSTRUMENT} Result.make(Result, strophes)
         end
      end

   do_all_bars (action: PROCEDURE[TUPLE[INTEGER_64]]) is
      do
         voices.bars.do_all(action)
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

end
