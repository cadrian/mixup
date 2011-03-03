class MIXUP_INSTRUMENT

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING
   voices: MIXUP_VOICES

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

   commit_lyrics is
      do
         -- TODO
      end

feature {}
   make (a_name: ABSTRACT_STRING; a_reference: MIXUP_NOTE_HEAD) is
      require
         a_name /= Void
      do
         name := a_name.intern
         create {FAST_ARRAY[COLLECTION[FIXED_STRING]]} strophes.make(0)
      ensure
         name = a_name.intern
      end

   strophes: COLLECTION[COLLECTION[FIXED_STRING]]
   current_strophe: COLLECTION[FIXED_STRING]

invariant
   name /= Void
   strophes /= Void

end
