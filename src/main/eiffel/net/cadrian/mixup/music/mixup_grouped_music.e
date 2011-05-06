-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
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
   as_beam, as_slur, as_phrasing_slur

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
            warning("invalid xuplet duration: does not divide cleanly. Expect strange results.")
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

   is_phrasing_slur: BOOLEAN is
      do
         Result := start_event_factory = start_phrasing_slur
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      local
         lyrics_manager: MIXUP_GROUPED_MUSIC_LYRICS_MANAGER
      do
         if xuplet_text /= Void then
            a_context.set_xuplet(xuplet_numerator, xuplet_denominator, xuplet_text)
         end
         create lyrics_manager.make(not (is_slur or is_phrasing_slur))
         create {MIXUP_EVENTS_ITERATOR_ON_DECORATED_MUSIC} Result.make(a_context, start_event_factory, end_event_factory, agent lyrics_manager.manage_lyrics, Precursor(a_context))
      end

feature {}
   as_beam (a_source: like source; a_reference: like reference) is
      require
         a_source /= Void
      do
         make(a_reference)
         source := a_source
         start_event_factory := start_beam
         end_event_factory := end_beam
      ensure
         source = a_source
         is_beam
      end

   as_slur (a_source: like source; a_reference: like reference) is
      require
         a_source /= Void
      do
         make(a_reference)
         source := a_source
         start_event_factory := start_slur
         end_event_factory := end_slur
      ensure
         source = a_source
         is_slur
      end

   as_phrasing_slur (a_source: like source; a_reference: like reference) is
      require
         a_source /= Void
      do
         make(a_reference)
         source := a_source
         start_event_factory := start_phrasing_slur
         end_event_factory := end_phrasing_slur
      ensure
         source = a_source
         is_phrasing_slur
      end

   start_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]
   end_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]

   start_beam: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_start_beam
      end

   create_start_beam (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_BEAM} Result.make(source, a_context.start_time, a_context.instrument.name, a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_beam : FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_end_beam
      end

   create_end_beam (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_BEAM} Result.make(source, a_context.start_time, a_context.instrument.name)
      end

   start_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_start_slur
      end

   create_start_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_SLUR} Result.make(source, a_context.start_time, a_context.instrument.name, a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_end_slur
      end

   create_end_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_SLUR} Result.make(source, a_context.start_time, a_context.instrument.name)
      end

   start_phrasing_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_start_phrasing_slur
      end

   create_start_phrasing_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_PHRASING_SLUR} Result.make(source, a_context.start_time, a_context.instrument.name, a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_phrasing_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      once
         Result := agent create_end_phrasing_slur
      end

   create_end_phrasing_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_PHRASING_SLUR} Result.make(source, a_context.start_time, a_context.instrument.name)
      end

end -- class MIXUP_GROUPED_MUSIC
