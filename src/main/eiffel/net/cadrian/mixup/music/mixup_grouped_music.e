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
         valid_anchor, out_in_tagged_out_memory
      end

insert
   MIXUP_VOICE
      redefine
         new_events_iterator, valid_anchor, out_in_tagged_out_memory
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
         Result := tag = tag_beam
      end

   is_slur: BOOLEAN is
      do
         Result := tag = tag_slur
      end

   is_phrasing_slur: BOOLEAN is
      do
         Result := tag = tag_phrasing_slur
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_EVENTS_ITERATOR_ON_DECORATED_MUSIC} Result.make(a_context, start_voices, end_voices, Void, new_events_iterator_(a_context, Precursor(a_context)))
      end

   out_in_tagged_out_memory is
      local
         closing: CHARACTER
      do
         inspect tag
         when tag_slur then
            tagged_out_memory.extend('(')
            closing := ')'
         when tag_phrasing_slur then
            tagged_out_memory.extend('{')
            closing := '}'
         when tag_beam then
            tagged_out_memory.extend('[')
            closing := ']'
         end
         tagged_out_memory.extend('#')
         id.append_in(tagged_out_memory)
         if xuplet_numerator /= xuplet_denominator then
            tagged_out_memory.extend(' ')
            xuplet_numerator.append_in(tagged_out_memory)
            tagged_out_memory.extend('/')
            xuplet_denominator.append_in(tagged_out_memory)
         end
         music.do_all(agent (mus: MIXUP_MUSIC) is
                         do
                            tagged_out_memory.extend(' ')
                            mus.out_in_tagged_out_memory
                         end)
         tagged_out_memory.extend(closing)
      end

feature {}
   new_events_iterator_ (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT; precursor_iterator: MIXUP_EVENTS_ITERATOR): MIXUP_EVENTS_ITERATOR is
      local
         lyrics_manager: MIXUP_GROUPED_MUSIC_LYRICS_MANAGER
      do
         a_context.set_voice_id(id)
         if xuplet_text /= Void then
            a_context.set_xuplet(xuplet_numerator, xuplet_denominator, xuplet_text)
         end
         create lyrics_manager.make(not (is_slur or is_phrasing_slur))
         create {MIXUP_EVENTS_ITERATOR_ON_DECORATED_MUSIC} Result.make(a_context, start_event_factory, end_event_factory, agent lyrics_manager.manage_lyrics, precursor_iterator)
      end

   as_beam (a_source: like source; a_reference: like reference) is
      require
         a_source /= Void
      do
         make(a_source, a_reference)
         start_event_factory := start_beam
         end_event_factory := end_beam
         tag := tag_beam
      ensure
         source = a_source
         is_beam
      end

   as_slur (a_source: like source; a_reference: like reference) is
      require
         a_source /= Void
      do
         make(a_source, a_reference)
         start_event_factory := start_slur
         end_event_factory := end_slur
         tag := tag_slur
      ensure
         source = a_source
         is_slur
      end

   as_phrasing_slur (a_source: like source; a_reference: like reference) is
      require
         a_source /= Void
      do
         make(a_source, a_reference)
         start_event_factory := start_phrasing_slur
         end_event_factory := end_phrasing_slur
         tag := tag_phrasing_slur
      ensure
         source = a_source
         is_phrasing_slur
      end

   start_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]
   end_event_factory: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT]

   start_beam: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_start_beam
      end

   create_start_beam (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_BEAM} Result.make(a_context.event_data(source), a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_beam : FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_end_beam
      end

   create_end_beam (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_BEAM} Result.make(a_context.event_data(source))
      end

   start_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_start_slur
      end

   create_start_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_SLUR} Result.make(a_context.event_data(source), a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_end_slur
      end

   create_end_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_SLUR} Result.make(a_context.event_data(source))
      end

   start_phrasing_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_start_phrasing_slur
      end

   create_start_phrasing_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_PHRASING_SLUR} Result.make(a_context.event_data(source), a_context.xuplet_numerator, a_context.xuplet_denominator, a_context.xuplet_text)
      end

   end_phrasing_slur: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_end_phrasing_slur
      end

   create_end_phrasing_slur (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_PHRASING_SLUR} Result.make(a_context.event_data(source))
      end

   start_voices: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_start_voices
      end

   create_start_voices (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_VOICES} Result.make(a_context.event_data(source), {FAST_ARRAY[INTEGER] << id >> })
      end

   end_voices: FUNCTION[TUPLE[MIXUP_EVENTS_ITERATOR_CONTEXT], MIXUP_EVENT] is
      do
         Result := agent create_end_voices
      end

   create_end_voices (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_VOICES} Result.make(a_context.event_data(source))
      end

feature {} -- tags
   tag: INTEGER_8
   tag_beam: INTEGER_8 is 1
   tag_slur: INTEGER_8 is 2
   tag_phrasing_slur: INTEGER_8 is 3

invariant
   tag.in_range(tag_beam, tag_phrasing_slur)

end -- class MIXUP_GROUPED_MUSIC
