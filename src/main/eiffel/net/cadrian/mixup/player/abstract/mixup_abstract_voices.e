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
deferred class MIXUP_ABSTRACT_VOICES[OUT_ -> MIXUP_ABSTRACT_OUTPUT,
                                     SEC_ -> MIXUP_ABSTRACT_SECTION[OUT_],
                                     ITM_ -> MIXUP_ABSTRACT_ITEM[OUT_, SEC_],
                                     VOI_ -> MIXUP_ABSTRACT_VOICE[OUT_, SEC_, ITM_]]

inherit
   MIXUP_ABSTRACT_ITEM[OUT_, SEC_]

feature {ANY}
   generate (context: MIXUP_CONTEXT; section: SEC_) is
      do
         voices.do_all_items(agent (ctx: MIXUP_CONTEXT; sec: SEC_; a_voice: VOI_) is
                             do
                                a_voice.generate(ctx, sec)
                             end(context, section, ?))
      end

feature {MIXUP_ABSTRACT_STAFF}
   map_in (map: DICTIONARY[VOI_, INTEGER]) is
      require
         map /= Void
      do
         voices.do_all(agent (a_voice: VOI_; a_map: DICTIONARY[VOI_, INTEGER]) is
                          do
                             a_map.put(a_voice, a_voice.id)
                          end(?, map))
      end

feature {}
   make (a_ids: TRAVERSABLE[INTEGER]; a_lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]) is
      require
         a_lyrics_gatherer /= Void
         not a_ids.is_empty
         all_different: (create {AVL_SET[INTEGER]}.from_collection(a_ids)).count = a_ids.count
      do
         create voices.make
         a_ids.do_all(agent (a_id: INTEGER; lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]) is
                         do
                            voices.add(new_voice(a_id, lyrics_gatherer), a_id)
                         end(?, a_lyrics_gatherer))
      ensure
         voices.count = a_ids.count
         a_ids.for_all(agent (a_id: INTEGER): BOOLEAN is do Result := voices.reference_at(a_id) /= Void and then voices.reference_at(a_id).id = a_id end)
      end

   voices: AVL_DICTIONARY[VOI_, INTEGER]

   new_voice (a_id: INTEGER; lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]): VOI_ is
      require
         lyrics_gatherer /= Void
      deferred
      ensure
         Result /= Void
      end

invariant
   voices /= Void

end -- class MIXUP_ABSTRACT_VOICES
