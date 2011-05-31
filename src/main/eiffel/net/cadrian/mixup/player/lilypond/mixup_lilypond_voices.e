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

feature {MIXUP_LILYPOND_STAFF}
   map_in (map: DICTIONARY[MIXUP_LILYPOND_VOICE, INTEGER]) is
      require
         map /= Void
      do
         voices.do_all(agent (a_voice: MIXUP_LILYPOND_VOICE; a_map: DICTIONARY[MIXUP_LILYPOND_VOICE, INTEGER]) is
                          do
                             a_map.put(a_voice, a_voice.id)
                          end(?, map))
      end

feature {}
   make (a_staff: MIXUP_LILYPOND_STAFF; a_ids: TRAVERSABLE[INTEGER]; a_reference: MIXUP_NOTE_HEAD; a_lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]) is
      require
         a_staff /= Void
         a_lyrics_gatherer /= Void
         not a_ids.is_empty
         all_different: (create {AVL_SET[INTEGER]}.from_collection(a_ids)).count = a_ids.count
      do
         create voices.make
         a_ids.do_all(agent (a_id: INTEGER; staff: MIXUP_LILYPOND_STAFF; a_reference: MIXUP_NOTE_HEAD; lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]) is
                         do
                            voices.add(create {MIXUP_LILYPOND_VOICE}.make(staff, a_id, a_reference, lyrics_gatherer), a_id)
                         end(?, a_staff, a_reference, a_lyrics_gatherer))
      ensure
         voices.count = a_ids.count
         a_ids.for_all(agent (a_id: INTEGER): BOOLEAN is do Result := voices.reference_at(a_id) /= Void and then voices.reference_at(a_id).id = a_id end)
      end

   voices: AVL_DICTIONARY[MIXUP_LILYPOND_VOICE, INTEGER]

invariant
   voices /= Void

end -- class MIXUP_LILYPOND_VOICES
