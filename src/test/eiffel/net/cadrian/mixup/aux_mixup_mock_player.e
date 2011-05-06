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
class AUX_MIXUP_MOCK_PLAYER

inherit
   MIXUP_CORE_PLAYER

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
         start_phrasing_slur as start_phrasing_slur_event,
         end_phrasing_slur as end_phrasing_slur_event,
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

   when_native (name: STRING; then_call: FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE]) is
      require
         name /= Void
      do
         native_map.put(then_call, name.intern)
      end

   native (a_source: MIXUP_SOURCE; name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         fun: FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE]
      do
         fun := native_map.reference_at(name.intern)
         if fun /= Void then
            Result := fun.item([a_context, args])
         end
      end

feature {ANY}
   context: MIXUP_CONTEXT

   set_context (a_context: like context) is
      do
         context := a_context
      end

   play_set_book (name: STRING) is
      do
         events_list.add_last(set_book_event(name))
      end

   play_end_book is
      do
         events_list.add_last(end_book_event)
      end

   play_set_score (name: STRING) is
      do
         events_list.add_last(set_score_event(name))
      end

   play_end_score is
      do
         events_list.add_last(end_score_event)
      end

   play_set_partitur (name: STRING) is
      do
         events_list.add_last(set_partitur_event(name))
      end

   play_end_partitur is
      do
         events_list.add_last(end_partitur_event)
      end

   play_set_instrument (name: STRING) is
      do
         events_list.add_last(set_instrument_event(name))
      end

   play_set_dynamics (instrument_name: ABSTRACT_STRING; dynamics, position: ABSTRACT_STRING) is
      do
         events_list.add_last(set_dynamics_event(instrument_name, dynamics, position))
      end

   play_set_note (instrument: STRING; note: MIXUP_NOTE) is
      do
         events_list.add_last(set_note_event(instrument, note))
      end

   play_next_bar (instrument, style: STRING) is
      do
         events_list.add_last(next_bar_event(instrument, style))
      end

   play_start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         events_list.add_last(start_beam_event(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   play_end_beam (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_beam_event(instrument))
      end

   play_start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         events_list.add_last(start_slur_event(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   play_end_slur (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_slur_event(instrument))
      end

   play_start_phrasing_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         events_list.add_last(start_phrasing_slur_event(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   play_end_phrasing_slur (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_phrasing_slur_event(instrument))
      end

   play_start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64) is
      do
         events_list.add_last(start_repeat_event(instrument,  volte))
      end

   play_end_repeat (instrument: ABSTRACT_STRING) is
      do
         events_list.add_last(end_repeat_event(instrument))
      end

feature {}
   events_list: COLLECTION[AUX_MIXUP_MOCK_EVENT]
   native_map: DICTIONARY[FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE], FIXED_STRING]

   make is
      do
         create {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]} events_list.make(0)
         create {HASHED_DICTIONARY[FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE], FIXED_STRING]} native_map.make
      end

invariant
   events_list /= Void
   native_map /= Void

end -- class AUX_MIXUP_MOCK_PLAYER
