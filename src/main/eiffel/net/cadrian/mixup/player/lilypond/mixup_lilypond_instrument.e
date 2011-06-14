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
   MIXUP_ABSTRACT_INSTRUMENT[MIXUP_LILYPOND_OUTPUT,
                             MIXUP_LILYPOND_SECTION,
                             MIXUP_LILYPOND_ITEM,
                             MIXUP_LILYPOND_VOICE,
                             MIXUP_LILYPOND_VOICES,
                             MIXUP_LILYPOND_STAFF]
      rename
         make as make_abstract
      redefine
         generate
      end

insert
   MIXUP_LILYPOND_CONTEXT

create {ANY}
   make

feature {MIXUP_ABSTRACT_PLAYER}
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
            Precursor(section)
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
         player := a_player
         make_abstract(a_context, a_name, a_voice_staff_ids)
      ensure
         context = a_context
         player = a_player
         name = a_name
         staffs.count = a_voice_staff_ids.count
         a_voice_staff_ids.for_all(agent (a_voice_ids: TRAVERSABLE[INTEGER]; a_id: INTEGER): BOOLEAN is do Result := staffs.fast_has(a_id) and then staffs.fast_reference_at(a_id).id = a_id end)
      end

   context_name: FIXED_STRING
   player: MIXUP_LILYPOND_PLAYER

   absolute_reference: MIXUP_NOTE_HEAD is
      once
         Result.set(create {MIXUP_SOURCE_UNKNOWN}, "a", 4)
      end

   template_instrument_staff: FIXED_STRING is
      once
         Result := "template.instrument_staff".intern
      end

   new_staff (voice_ids: TRAVERSABLE[INTEGER]; id: INTEGER): MIXUP_LILYPOND_STAFF is
      do
         create Result.make(Current, player, id, voice_ids, absolute_reference)
      end

end -- class MIXUP_LILYPOND_INSTRUMENT
