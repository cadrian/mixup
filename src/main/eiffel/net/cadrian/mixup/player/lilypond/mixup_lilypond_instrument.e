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

insert
   MIXUP_LILYPOND_CONTEXT

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING

feature {MIXUP_LILYPOND_PLAYER}
   set_dynamics (a_staff_id: INTEGER; dynamics, position: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).set_dynamics(dynamics, position)
      end

   set_note (a_staff_id: INTEGER; note: MIXUP_NOTE) is
      do
         staffs.reference_at(a_staff_id).set_note(note)
      end

   next_bar (a_staff_id: INTEGER; style: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).next_bar(style)
      end

   start_beam (a_staff_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).start_beam(xuplet_numerator, xuplet_denominator, text)
      end

   end_beam (a_staff_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_beam
      end

   start_slur (a_staff_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).start_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_slur (a_staff_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_slur
      end

   start_phrasing_slur (a_staff_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).start_phrasing_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_phrasing_slur (a_staff_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_phrasing_slur
      end

   start_repeat (a_staff_id: INTEGER; volte: INTEGER_64) is
      do
         staffs.reference_at(a_staff_id).start_repeat(volte)
      end

   end_repeat (a_staff_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_repeat
      end

feature {MIXUP_LILYPOND_PLAYER}
   generate (output: OUTPUT_STREAM) is
      require
         output.is_connected
      local
         staff_type: STRING
      do
         if staffs.count = 1 then
            staffs.first.generate(context, output, True)
         else
            if staffs.count = 2 then
               staff_type := once "PianoStaff"
            else
               staff_type := once "ChoirStaff"
            end
            context_name := get_string(context, template_instrument_staff, staff_type)

            output.put_line(once "         \new " + context_name.out + " = %"" + name.out + "%" <<")
            generate_context(context, output, Current)
            staffs.do_all(agent {MIXUP_LILYPOND_STAFF}.generate(context, output, False))
            output.put_line(once "         >>")
         end
      end

feature {}
   make (a_context: like context; a_player: like player; a_name: like name; a_staff_ids: TRAVERSABLE[INTEGER]) is
      require
         a_context /= Void
         a_player /= Void
         a_name /= Void
         a_staff_ids /= Void
      do
         context := a_context
         player := a_player
         name := a_name
         create staffs.make
         a_staff_ids.do_all(agent (id: INTEGER) is
                               do
                                  staffs.add(create {MIXUP_LILYPOND_STAFF}.make(player, Current, id, absolute_reference), id);
                               end)
      ensure
         context = a_context
         player = a_player
         name = a_name
      end

   player: MIXUP_LILYPOND_PLAYER
   staffs: AVL_DICTIONARY[MIXUP_LILYPOND_STAFF, INTEGER]
   context: MIXUP_CONTEXT
   context_name: FIXED_STRING

   absolute_reference: MIXUP_NOTE_HEAD is
      once
         Result.set(create {MIXUP_SOURCE_UNKNOWN}, "a", 4)
      end

   template_instrument_staff: FIXED_STRING is
      once
         Result := "template.instrument_staff".intern
      end

invariant
   context /= Void
   player /= Void
   name /= Void

end -- class MIXUP_LILYPOND_INSTRUMENT
