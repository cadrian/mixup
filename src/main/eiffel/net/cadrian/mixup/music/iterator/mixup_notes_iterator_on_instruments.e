class MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS
--
-- Iterator on parallel instruments
--

inherit
   MIXUP_NOTES_PARALLEL_ITERATOR

create {MIXUP_MIXER}
   make

feature {}
   make (a_instruments: like instruments) is
      require
         a_instruments /= Void
      do
         instruments := a_instruments
         start
      ensure
         instruments = a_instruments
      end

   add_notes_iterator is
      do
         instruments.do_all(agent add_note_iterator)
      end

   add_note_iterator (a_instrument: MIXUP_INSTRUMENT) is
      do
         notes.add_last(a_instrument.voices.new_note_iterator)
      end

   count: INTEGER is
      do
         Result := instruments.count
      end

   instruments: TRAVERSABLE[MIXUP_INSTRUMENT]

invariant
   instruments /= Void

end
