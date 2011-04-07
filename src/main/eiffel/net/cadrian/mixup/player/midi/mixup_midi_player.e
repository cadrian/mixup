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
   MIXUP_PLAYER

create {ANY}
   make

feature {ANY}
   native (a_source: MIXUP_SOURCE; name: STRING; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         fatal("unknown native function: " + name)
      end

feature {ANY}
   set_score (name: ABSTRACT_STRING) is
      do
      end

   end_score is
      do
      end

   set_book (name: ABSTRACT_STRING) is
      do
      end

   end_book is
      do
      end

   set_partitur (name: ABSTRACT_STRING) is
      do
      end

   end_partitur is
      do
      end

   set_instrument (name: ABSTRACT_STRING) is
      do
      end

   set_dynamics (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; dynamics, position: ABSTRACT_STRING) is
      do
      end

   set_note (instrument: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE) is
      do
      end

   next_bar (instrument, style: ABSTRACT_STRING) is
      do
         -- ignored
      end

   start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64) is
      do
      end

   end_repeat (instrument: ABSTRACT_STRING) is
      do
      end

feature {}
   make is
      do
      end

end -- class MIXUP_MIDI_PLAYER
