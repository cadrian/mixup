class MIXUP_NOTES_ITERATOR_ON_VOICES
--
-- Iterator on parallel voices
--

inherit
   MIXUP_NOTES_PARALLEL_ITERATOR

create {MIXUP_VOICES}
   make

feature {}
   make (a_context: like context; a_voices: like voices) is
      require
         a_voices /= Void
      do
         context := a_context
         voices := a_voices
         start
      ensure
         voices = a_voices
      end

   add_notes_iterator is
      do
         voices.do_all(agent add_note_iterator)
      end

   add_note_iterator (a_voice: MIXUP_VOICE) is
      do
         notes.add_last(a_voice.new_note_iterator(context))
      end

   count: INTEGER is
      do
         Result := voices.count
      end

   voices: TRAVERSABLE[MIXUP_VOICE]
   context: MIXUP_NOTES_ITERATOR_CONTEXT
   start_time: INTEGER_64

invariant
   voices /= Void

end
