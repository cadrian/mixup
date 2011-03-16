class AUX_MIXUP_MOCK_PLAYER

inherit
   MIXUP_PLAYER

insert
   AUX_MIXUP_MOCK_PLAYER_EVENTS
      rename
         set_score as set_score_event,
         end_score as end_score_event,
         set_book as set_book_event,
         end_book as end_book_event,
         set_partitur as set_partitur_event,
         end_partitur as end_partitur_event,
         set_instrument as set_instrument_event,
         set_dynamics as set_dynamics_event,
         set_note as set_note_event,
         next_bar as next_bar_event,
         start_beam as start_beam_event,
         end_beam as end_beam_event,
         start_slur as start_slur_event,
         end_slur as end_slur_event,
         start_tie as start_tie_event,
         end_tie as end_tie_event,
         start_repeat as start_repeat_event,
         end_repeat as end_repeat_event
      end

create {ANY}
   make

feature {ANY}
   events: TRAVERSABLE[AUX_MIXUP_MOCK_EVENT] is
      do
         Result := events_list
      end

feature {ANY}
   set_book (name: STRING) is
      do
         events_list.add_last(set_book_event(name))
      end

   end_book is
      do
         events_list.add_last(end_book_event)
      end

   set_score (name: STRING) is
      do
         events_list.add_last(set_score_event(name))
      end

   end_score is
      do
         events_list.add_last(end_score_event)
      end

   set_partitur (name: STRING) is
      do
         events_list.add_last(set_partitur_event(name))
      end

   end_partitur is
      do
         events_list.add_last(end_partitur_event)
      end

   set_instrument (name: STRING) is
      do
         events_list.add_last(set_instrument_event(name))
      end

   set_dynamics (instrument_name: ABSTRACT_STRING; dynamics, position: ABSTRACT_STRING) is
      do
         events_list.add_last(set_dynamics_event(instrument_name, dynamics, position))
      end

   set_note (instrument: STRING; note: MIXUP_NOTE) is
      do
         events_list.add_last(set_note_event(instrument, note))
      end

   next_bar (instrument, style: STRING) is
      do
         events_list.add_last(next_bar_event(instrument, style))
      end

   start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         events_list.add_last(start_beam_event(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   end_beam (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_beam_event(instrument))
      end

   start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         events_list.add_last(start_slur_event(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   end_slur (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_slur_event(instrument))
      end

   start_tie (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         events_list.add_last(start_tie_event(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   end_tie (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_tie_event(instrument))
      end

   start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64) is
      do
         events_list.add_last(start_repeat_event(instrument,  volte))
      end

   end_repeat (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_repeat_event(instrument))
      end

feature {}
   events_list: COLLECTION[AUX_MIXUP_MOCK_EVENT]

   make is
      do
         create {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]} events_list.make(0)
      end

invariant
   events_list /= Void

end
