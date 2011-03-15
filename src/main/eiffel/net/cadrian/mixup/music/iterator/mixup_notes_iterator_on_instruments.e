class MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS
--
-- Iterator on parallel instruments
--

inherit
   MIXUP_NOTES_PARALLEL_ITERATOR
   MIXUP_CONTEXT_VISITOR
      undefine
         is_equal
      redefine
         start_instrument
      end

create {MIXUP_MIXER}
   make

feature {MIXUP_INSTRUMENT}
   start_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         a_instrument.commit
         instruments.add_last(a_instrument)
      end

feature {}
   make (a_context: MIXUP_CONTEXT) is
      require
         a_context /= Void
      do
         create {FAST_ARRAY[MIXUP_INSTRUMENT]} instruments.make(0)
         a_context.accept(Current)
         start
      end

   add_notes_iterator is
      do
         instruments.do_all(agent add_note_iterator)
      end

   add_note_iterator (a_instrument: MIXUP_INSTRUMENT) is
      do
         notes.add_last(a_instrument.new_events_iterator)
      end

   count: INTEGER is
      do
         Result := instruments.count
      end

   instruments: COLLECTION[MIXUP_INSTRUMENT]

invariant
   instruments /= Void

end
