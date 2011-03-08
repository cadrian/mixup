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
   xuplet_numerator: INTEGER_64
   xuplet_denominator: INTEGER_64
   xuplet_text: FIXED_STRING

   set_xuplet (a_numerator: like xuplet_numerator; a_denominator: like xuplet_denominator; a_text: like xuplet_text) is
      require
         a_numerator > 0
         a_denominator > 0
         a_text /= Void
      do
         xuplet_numerator := a_numerator
         xuplet_denominator := a_denominator
         xuplet_text := a_text

         if (duration // a_numerator) * a_numerator /= duration then
            not_yet_implemented -- error: invalid xuplet duration: does not divide cleanly
         end
      end

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
         if xuplet_text /= Void then
            a_context.set_xuplet(xuplet_numerator, xuplet_denominator, xuplet_text)
         end
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

   start_event: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, INTEGER_64, INTEGER_64, FIXED_STRING]]
   end_event: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]]

   start_beam: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, INTEGER_64, INTEGER_64, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_start_beam
      end

   end_beam: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_end_beam
      end

   start_slur: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, INTEGER_64, INTEGER_64, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_start_slur
      end

   end_slur: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_end_slur
      end

   start_tie: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING, INTEGER_64, INTEGER_64, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_start_tie
      end

   end_tie: PROCEDURE[TUPLE[MIXUP_EVENTS, FIXED_STRING]] is
      once
         Result := agent {MIXUP_EVENTS}.fire_end_tie
      end

end
