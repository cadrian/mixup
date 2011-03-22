class MIXUP_EVENTS_ITERATOR_ON_VOICES
--
-- Iterator on parallel voices
--

inherit
   MIXUP_EVENTS_PARALLEL_ITERATOR

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
         voices.do_all(agent add_events_iterator)
      end

   add_events_iterator (a_voice: MIXUP_VOICE) is
      do
         notes.add_last(a_voice.new_events_iterator(context))
      end

   count: INTEGER is
      do
         Result := voices.count
      end

   voices: TRAVERSABLE[MIXUP_VOICE]
   context: MIXUP_EVENTS_ITERATOR_CONTEXT
   start_time: INTEGER_64

invariant
   voices /= Void

end
