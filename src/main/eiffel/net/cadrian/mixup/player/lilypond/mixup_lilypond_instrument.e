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
      redefine
         generate
      end

insert
   MIXUP_LILYPOND_CONTEXT

create {ANY}
   make

feature {MIXUP_LILYPOND_PLAYER}
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
   context_name: FIXED_STRING

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
         create Result.make(Current, id, voice_ids, absolute_reference)
      end

end -- class MIXUP_LILYPOND_INSTRUMENT
