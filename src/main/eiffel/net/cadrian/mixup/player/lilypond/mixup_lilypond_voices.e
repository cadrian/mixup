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
class MIXUP_LILYPOND_VOICES

inherit
   MIXUP_LILYPOND_ITEM
   MIXUP_ABSTRACT_VOICES[MIXUP_LILYPOND_OUTPUT,
                         MIXUP_LILYPOND_SECTION,
                         MIXUP_LILYPOND_ITEM,
                         MIXUP_LILYPOND_VOICE]
      rename
         make as make_abstract
      redefine
         generate
      end

create {ANY}
   make

feature {ANY}
   valid_reference: BOOLEAN is
      do
         Result := voices.exists(agent (voice: MIXUP_LILYPOND_VOICE; id: INTEGER): BOOLEAN is do Result := voice.valid_reference end)
      end

   reference: MIXUP_NOTE_HEAD is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := voices.lower
         until
            found
         loop
            found := voices.item(i).valid_reference
            if found then
               Result := voices.item(i).reference
            end
            i := i + 1
         end
      end

   can_append: BOOLEAN is
      do
         Result := voices.exists(agent (voice: MIXUP_LILYPOND_VOICE; id: INTEGER): BOOLEAN is do Result := voice.can_append end)
      end

   append_first (a_string: ABSTRACT_STRING) is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := voices.lower
         until
            found
         loop
            found := voices.item(i).can_append
            if found then
               voices.item(i).append_first(a_string)
            end
            i := i + 1
         end
      end

   append_last (a_string: ABSTRACT_STRING) is
      local
         i: INTEGER; found: BOOLEAN
      do
         from
            i := voices.upper
         until
            found
         loop
            found := voices.item(i).can_append
            if found then
               voices.item(i).append_last(a_string)
            end
            i := i - 1
         end
      end

   generate (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION) is
      local
         is_first: AGGREGATOR[MIXUP_LILYPOND_VOICE, BOOLEAN]
         dummy: BOOLEAN
      do
         if voices.count = 1 then
            voices.first.generate(context, section)
         else
            section.set_body(once "<<%N")
            dummy := is_first.map(voices,
                         agent (voice: MIXUP_LILYPOND_VOICE; first: BOOLEAN; a_context: MIXUP_CONTEXT; a_section: MIXUP_LILYPOND_SECTION): BOOLEAN is
                            do
                               if not first then
                                  a_section.set_body(once "\\%N")
                               end
                               a_section.set_body(once "{%N")
                               voice.generate(a_context, a_section)
                               a_section.set_body(once "}%N")
                            ensure
                               not_first: not Result
                            end(?, ?, context, section),
                            True)
            check not dummy end
            section.set_body(once ">>%N")
         end
      end

feature {}
   make (a_ids: TRAVERSABLE[INTEGER]; a_reference: like first_reference; a_lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]) is
      do
         first_reference := a_reference
         make_abstract(a_ids, a_lyrics_gatherer)
      end

   first_reference: MIXUP_NOTE_HEAD

   new_voice (a_id: INTEGER; lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]): MIXUP_LILYPOND_VOICE is
      do
         create Result.make(a_id, first_reference, lyrics_gatherer)
      end

end -- class MIXUP_LILYPOND_VOICES
