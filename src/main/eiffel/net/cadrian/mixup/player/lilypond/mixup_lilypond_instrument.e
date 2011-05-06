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
class MIXUP_LILYPOND_INSTRUMENT

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING

feature {MIXUP_LILYPOND_PLAYER}
   set_dynamics (dynamics, position: ABSTRACT_STRING) is
      do
         current_staff.set_dynamics(dynamics, position)
      end

   set_note (note: MIXUP_NOTE) is
      do
         current_staff.set_note(note)
      end

   next_bar (style: ABSTRACT_STRING) is
      do
         current_staff.next_bar(style)
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         current_staff.start_beam(xuplet_numerator, xuplet_numerator, text)
      end

   end_beam is
      do
         current_staff.end_beam
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         current_staff.start_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_slur is
      do
         current_staff.end_slur
      end

   start_tie (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         current_staff.start_tie(xuplet_numerator, xuplet_denominator, text)
      end

   end_tie is
      do
         current_staff.end_tie
      end

   start_repeat (volte: INTEGER_64) is
      do
         current_staff.start_repeat(volte)
      end

   end_repeat is
      do
         current_staff.end_repeat
      end

feature {MIXUP_LILYPOND_PLAYER}
   generate (output: OUTPUT_STREAM) is
      require
         output.is_connected
      do
         staffs.do_all(agent {MIXUP_LILYPOND_STAFF}.generate(context, output))
      end

feature {}
   make (a_context: like context; a_player: like player; a_name: like name) is
      require
         a_context /= Void
         a_player /= Void
         a_name /= Void
      do
         context := a_context
         player := a_player
         name := a_name
         create staffs.with_capacity(2)
         staffs.add_last(create {MIXUP_LILYPOND_STAFF}.make(a_player, Current, 1, absolute_reference));
      ensure
         context = a_context
         player = a_player
         name = a_name
      end

   player: MIXUP_LILYPOND_PLAYER
   staffs: FAST_ARRAY[MIXUP_LILYPOND_STAFF]
   current_staff_index: INTEGER
   context: MIXUP_CONTEXT

   current_staff: MIXUP_LILYPOND_STAFF is
      do
         Result := staffs.item(current_staff_index)
      end

   absolute_reference: MIXUP_NOTE_HEAD is
      once
         Result.set(create {MIXUP_SOURCE_UNKNOWN}, "a", 4)
      end

invariant
   context /= Void
   player /= Void
   name /= Void
   staffs.valid_index(current_staff_index)

end -- class MIXUP_LILYPOND_INSTRUMENT
