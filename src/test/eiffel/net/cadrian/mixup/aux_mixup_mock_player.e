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
         start_voices as start_voices_event,
         end_voices as end_voices_event
      end

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING is
      once
         Result := "mock player".intern
      end

   events: TRAVERSABLE[AUX_MIXUP_MOCK_EVENT] is
      do
         Result := events_list
      end

   when_native (a_name: STRING; then_call: FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE]) is
      require
         a_name /= Void
      do
         native_map.put(then_call, a_name.intern)
      end

   native (a_def_source, a_call_source: MIXUP_SOURCE; a_name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         fun: FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE]
      do
         fun := native_map.reference_at(a_name.intern)
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

   play_set_book (a_name: STRING) is
      do
         add_event(set_book_event(a_name))
      end

   play_end_book is
      do
         add_event(end_book_event)
      end

   play_set_score (a_name: STRING) is
      do
         add_event(set_score_event(a_name))
      end

   play_end_score is
      do
         add_event(end_score_event)
      end

   play_set_partitur (a_name: STRING) is
      do
         add_event(set_partitur_event(a_name))
      end

   play_end_partitur is
      do
         add_event(end_partitur_event)
      end

   play_set_instrument (a_name: STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]) is
      do
         add_event(set_instrument_event(a_name, voice_staff_ids))
      end

   play_start_voices (a_data: MIXUP_EVENT_DATA; voice_ids: TRAVERSABLE[INTEGER]) is
      do
         add_event(start_voices_event(a_data.instrument, a_data.staff_id, voice_ids))
      end

   play_end_voices (a_data: MIXUP_EVENT_DATA) is
      do
         add_event(end_voices_event(a_data.instrument, a_data.staff_id))
      end

   play_set_dynamics (a_data: MIXUP_EVENT_DATA; dynamics, position: ABSTRACT_STRING; is_standard: BOOLEAN) is
      do
         add_event(set_dynamics_event(a_data.instrument, a_data.staff_id, dynamics, position, is_standard))
      end

   play_set_note (a_data: MIXUP_EVENT_DATA; note: MIXUP_NOTE) is
      do
         add_event(set_note_event(a_data.instrument, a_data.staff_id, note))
      end

   play_next_bar (a_data: MIXUP_EVENT_DATA; style: STRING) is
      do
         add_event(next_bar_event(a_data.instrument, a_data.staff_id, style))
      end

   play_start_beam (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         add_event(start_beam_event(a_data.instrument, a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text))
      end

   play_end_beam (a_data: MIXUP_EVENT_DATA) is
      do
         add_event(end_beam_event(a_data.instrument, a_data.staff_id))
      end

   play_start_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         add_event(start_slur_event(a_data.instrument, a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text))
      end

   play_end_slur (a_data: MIXUP_EVENT_DATA) is
      do
         add_event(end_slur_event(a_data.instrument, a_data.staff_id))
      end

   play_start_phrasing_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         add_event(start_phrasing_slur_event(a_data.instrument, a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text))
      end

   play_end_phrasing_slur (a_data: MIXUP_EVENT_DATA) is
      do
         add_event(end_phrasing_slur_event(a_data.instrument, a_data.staff_id))
      end

   play_start_repeat (a_data: MIXUP_EVENT_DATA; volte: INTEGER_64) is
      do
         add_event(start_repeat_event(a_data.instrument, a_data.staff_id, volte))
      end

   play_end_repeat (a_data: MIXUP_EVENT_DATA) is
      do
         add_event(end_repeat_event(a_data.instrument, a_data.staff_id))
      end

feature {}
   events_list: COLLECTION[AUX_MIXUP_MOCK_EVENT]
   native_map: DICTIONARY[FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE], FIXED_STRING]

   add_event (a_event: AUX_MIXUP_MOCK_EVENT) is
      do
         log.info.put_line(once " => " + a_event.out)
         events_list.add_last(a_event)
      end

   make is
      do
         create {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]} events_list.make(0)
         create {HASHED_DICTIONARY[FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE], FIXED_STRING]} native_map.make
      end

invariant
   events_list /= Void
   native_map /= Void

end -- class AUX_MIXUP_MOCK_PLAYER
