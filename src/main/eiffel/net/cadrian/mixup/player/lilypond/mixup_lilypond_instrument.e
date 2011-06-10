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

inherit
   MIXUP_ABSTRACT_INSTRUMENT[MIXUP_LILYPOND_OUTPUT, MIXUP_LILYPOND_SECTION]

insert
   MIXUP_LILYPOND_CONTEXT

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING

feature {MIXUP_ABSTRACT_PLAYER}
   start_voices (a_staff_id, a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]) is
      do
         staffs.reference_at(a_staff_id).start_voices(a_voice_id, voice_ids)
      end

   end_voices (a_staff_id, a_voice_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_voices(a_voice_id)
      end

   set_dynamics (a_staff_id, a_voice_id: INTEGER; dynamics, position: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).set_dynamics(a_voice_id, dynamics, position)
      end

   set_note (a_staff_id, a_voice_id: INTEGER; time: INTEGER_64; note: MIXUP_NOTE) is
      do
         staffs.reference_at(a_staff_id).set_note(a_voice_id, time, note)
      end

   next_bar (a_staff_id, a_voice_id: INTEGER; style: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).next_bar(a_voice_id, style)
      end

   start_beam (a_staff_id, a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).start_beam(a_voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   end_beam (a_staff_id, a_voice_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_beam(a_voice_id)
      end

   start_slur (a_staff_id, a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).start_slur(a_voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   end_slur (a_staff_id, a_voice_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_slur(a_voice_id)
      end

   start_phrasing_slur (a_staff_id, a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         staffs.reference_at(a_staff_id).start_phrasing_slur(a_voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   end_phrasing_slur (a_staff_id, a_voice_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_phrasing_slur(a_voice_id)
      end

   start_repeat (a_staff_id, a_voice_id: INTEGER; volte: INTEGER_64) is
      do
         staffs.reference_at(a_staff_id).start_repeat(a_voice_id, volte)
      end

   end_repeat (a_staff_id, a_voice_id: INTEGER) is
      do
         staffs.reference_at(a_staff_id).end_repeat(a_voice_id)
      end

   string_event (a_staff_id, a_voice_id: INTEGER; a_string: FIXED_STRING) is
      require
         a_string /= Void
      do
         staffs.reference_at(a_staff_id).string_event(a_voice_id, a_string)
      end

feature {MIXUP_ABSTRACT_PLAYER}
   generate (section: MIXUP_LILYPOND_SECTION) is
      local
         staff_type: STRING
      do
         if staffs.count = 1 then
            staffs.first.generate(context, section, True)
         else
            if staffs.count = 2 then
               staff_type := once "PianoStaff"
            else
               staff_type := once "ChoirStaff"
            end
            context_name := get_string(context, template_instrument_staff, staff_type)

            section.set_body(once "\new ")
            section.set_body(context_name)
            section.set_body(once " = %"")
            section.set_body(name)
            section.set_body(once "%" <<%N")
            generate_context(context, section, Current)
            staffs.do_all(agent {MIXUP_LILYPOND_STAFF}.generate(context, section, False))
            section.set_body(once ">>%N")
         end
      end

feature {}
   make (a_context: like context; a_player: like player; a_name: like name; a_voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]) is
      require
         a_context /= Void
         a_player /= Void
         a_name /= Void
         a_voice_staff_ids /= Void
      do
         context := a_context
         player := a_player
         name := a_name
         create staffs.make
         a_voice_staff_ids.do_all(agent (voice_ids: TRAVERSABLE[INTEGER]; id: INTEGER) is
                                     do
                                        staffs.add(create {MIXUP_LILYPOND_STAFF}.make(player, Current, id, voice_ids, absolute_reference), id);
                                     end)
      ensure
         context = a_context
         player = a_player
         name = a_name
         staffs.count = a_voice_staff_ids.count
         a_voice_staff_ids.for_all(agent (a_voice_ids: TRAVERSABLE[INTEGER]; a_id: INTEGER): BOOLEAN is do Result := staffs.fast_has(a_id) and then staffs.fast_reference_at(a_id).id = a_id end)
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
