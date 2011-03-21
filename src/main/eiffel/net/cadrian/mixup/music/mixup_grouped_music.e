class MIXUP_GROUPED_MUSIC

inherit
   MIXUP_COMPOUND_MUSIC
      redefine
         valid_anchor
      end

insert
   MIXUP_VOICE
      redefine
         new_events_iterator, valid_anchor
      end

create {ANY}
   as_beam, as_slur, as_tie

feature {ANY}
   valid_anchor: BOOLEAN is True

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
         Result := start_event_factory = start_beam
      end

   is_slur: BOOLEAN is
      do
         Result := start_event_factory = start_slur
      end

   is_tie: BOOLEAN is
      do
         Result := start_event_factory = start_tie
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      local
         lyrics_manager: MIXUP_GROUPED_MUSIC_LYRICS_MANAGER
      do
         if xuplet_text /= Void then
            a_context.set_xuplet(xuplet_numerator, xuplet_denominator, xuplet_text)
         end
         create lyrics_manager.make(not (is_slur or is_tie))
         create {MIXUP_NOTES_ITERATOR_ON_DECORATED_MUSIC} Result.make(a_context, start_event_factory, end_event_factory, agent lyrics_manager.manage_lyrics, Precursor(a_context))
      end

feature {}
   as_beam (a_reference: like reference) is
      do
         make(a_reference)
         start_event_factory := start_beam
         end_event_factory := end_beam
      ensure
         is_beam
      end

   as_slur (a_reference: like reference) is
      do
         make(a_reference)
         start_event_factory := start_slur
         end_event_factory := end_slur
      ensure
         is_slur
      end

   as_tie (a_reference: like reference) is
      do
         make(a_reference)
         start_event_factory := start_tie
         end_event_factory := end_tie
      ensure
         is_tie
      end

   start_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]
   end_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]

   start_beam: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_start_beam
      end

   create_start_beam (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_BEAM} Result.make(a_context.start_time, a_context.instrument.name, a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_beam : FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_end_beam
      end

   create_end_beam (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_BEAM} Result.make(a_context.start_time, a_context.instrument.name)
      end

   start_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_start_slur
      end

   create_start_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_SLUR} Result.make(a_context.start_time, a_context.instrument.name, a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_end_slur
      end

   create_end_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_SLUR} Result.make(a_context.start_time, a_context.instrument.name)
      end

   start_tie: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_start_tie
      end

   create_start_tie (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_TIE} Result.make(a_context.start_time, a_context.instrument.name, a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_tie: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_end_tie
      end

   create_end_tie (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_TIE} Result.make(a_context.start_time, a_context.instrument.name)
      end

end
