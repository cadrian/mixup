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
class MIXUP_MIDI_PLAYER

inherit
   MIXUP_CORE_PLAYER

create {ANY}
   make

feature {ANY}
   set_context (a_context: MIXUP_CONTEXT) is
      do
      end

   native (a_source: MIXUP_SOURCE; name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         warning_at(a_source, "MIDI: unknown native function: " + name)
      end

feature {ANY}
   play_set_score (name: ABSTRACT_STRING) is
      do
      end

   play_end_score is
      do
      end

   play_set_book (name: ABSTRACT_STRING) is
      do
      end

   play_end_book is
      do
      end

   play_set_partitur (name: ABSTRACT_STRING) is
      do
      end

   play_end_partitur is
      do
      end

   play_set_instrument (name: ABSTRACT_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]) is
      do
      end

   play_set_dynamics (a_data: MIXUP_EVENT_DATA; dynamics, position: ABSTRACT_STRING) is
      do
      end

   play_set_note (a_data: MIXUP_EVENT_DATA; note: MIXUP_NOTE) is
      do
      end

   play_next_bar (a_data: MIXUP_EVENT_DATA; style: ABSTRACT_STRING) is
      do
      end

   play_start_beam (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   play_end_beam (a_data: MIXUP_EVENT_DATA) is
      do
      end

   play_start_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   play_end_slur (a_data: MIXUP_EVENT_DATA) is
      do
      end

   play_start_phrasing_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   play_end_phrasing_slur (a_data: MIXUP_EVENT_DATA) is
      do
      end

   play_start_repeat (a_data: MIXUP_EVENT_DATA; volte: INTEGER_64) is
      do
      end

   play_end_repeat (a_data: MIXUP_EVENT_DATA) is
      do
      end

feature {}
   make is
      do
      end

end -- class MIXUP_MIDI_PLAYER
