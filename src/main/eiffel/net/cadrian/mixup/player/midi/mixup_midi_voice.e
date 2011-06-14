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
class MIXUP_MIDI_VOICE

inherit
   MIXUP_ABSTRACT_VOICE[MIXUP_MIDI_OUTPUT_STREAM,
                        MIXUP_MIDI_SECTION,
                        MIXUP_MIDI_ITEM
                        ]

create {ANY}
   make

feature {MIXUP_ABSTRACT_STAFF}
   add_item (a_item: MIXUP_MIDI_ITEM) is
      do
         items.add_last(a_item)
      end

   set_dynamics (a_dynamics, position: ABSTRACT_STRING) is
      do
      end

   set_note (a_time: INTEGER_64; a_note: MIXUP_NOTE) is
      do
      end

   next_bar (style: ABSTRACT_STRING) is
      do
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_beam is
      do
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_slur is
      do
      end

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
      end

   end_phrasing_slur is
      do
      end

   start_repeat (volte: INTEGER_64) is
      do
      end

   end_repeat is
      do
      end

end -- class MIXUP_MIDI_VOICE
