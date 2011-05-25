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
   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      local
         is_first: AGGREGATOR[MIXUP_LILYPOND_VOICE, BOOLEAN]
         dummy: BOOLEAN
      do
         if voices.count = 1 then
            voices.first.generate(context, output)
         else
            output.put_line(once "<<")
            dummy := is_first.map(voices,
                         agent (voice: MIXUP_LILYPOND_VOICE; first: BOOLEAN; a_context: MIXUP_CONTEXT; a_output: OUTPUT_STREAM): BOOLEAN is
                            do
                               if not first then
                                  a_output.put_line(once "\\")
                               end
                               a_output.put_line(once "{")
                               voice.generate(a_context, a_output)
                               a_output.put_line(once "}")
                            ensure
                               not_first: not Result
                            end(?, ?, context, output),
                            True)
            check not dummy end
            output.put_line(once ">>")
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
         a_ids.do_all(agent (a_id: INTEGER; staff: MIXUP_LILYPOND_STAFF; reference: MIXUP_NOTE_HEAD; lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]) is
                         do
                            voices.add(create {MIXUP_LILYPOND_VOICE}.make(staff, a_id, reference, lyrics_gatherer), a_id)
                         end(?, a_staff, a_reference, a_lyrics_gatherer))
      ensure
         voices.count = a_ids.count
         a_ids.for_all(agent (a_id: INTEGER): BOOLEAN is do Result := voices.reference_at(a_id) /= Void and then voices.reference_at(a_id).id = a_id end)
      end

   voices: AVL_DICTIONARY[MIXUP_LILYPOND_VOICE, INTEGER]

invariant
   voices /= Void

end -- class MIXUP_LILYPOND_VOICES
