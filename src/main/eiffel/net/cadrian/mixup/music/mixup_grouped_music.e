class MIXUP_GROUPED_MUSIC

inherit
   MIXUP_COMPOUND_MUSIC

insert
   MIXUP_VOICE
      export
         {MIXUP_VOICE} consolidate_bars
      redefine
         new_events_iterator
      end

create {ANY}
   as_beam, as_slur, as_tie

feature {ANY}
   is_beam: BOOLEAN is
      do
         Result := start_event = start_beam
      end

   is_slur: BOOLEAN is
      do
         Result := start_event = start_slur
      end

   is_tie: BOOLEAN is
      do
         Result := start_event = start_tie
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_NOTES_ITERATOR_ON_GROUP} Result.make(a_context, duration, start_event, end_event, Precursor(a_context))
      end

feature {}
   as_beam (a_reference: like reference) is
      do
         make(a_reference)
         start_event := start_beam
         end_event := end_beam
      ensure
         is_beam
      end

   as_slur (a_reference: like reference) is
      do
         make(a_reference)
         start_event := start_slur
         end_event := end_slur
      ensure
         is_slur
      end

   as_tie (a_reference: like reference) is
      do
         make(a_reference)
         start_event := start_tie
         end_event := end_tie
      ensure
         is_tie
      end

   start_event: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, FIXED_STRING]]
   end_event: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]]

   start_beam: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_start_beam
      end

   end_beam: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_end_beam
      end

   start_slur: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_start_slur
      end

   end_slur: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_end_slur
      end

   start_tie: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_start_tie
      end

   end_tie: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_end_tie
      end

end
