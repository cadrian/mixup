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
deferred class MIXUP_ABSTRACT_STAFF[OUT_ -> MIXUP_ABSTRACT_OUTPUT,
                                    SEC_ -> MIXUP_ABSTRACT_SECTION[OUT_],
                                    ITM_ -> MIXUP_ABSTRACT_ITEM[OUT_, SEC_],
                                    VOI_ -> MIXUP_ABSTRACT_VOICE[OUT_, SEC_, ITM_],
                                    VOS_ -> MIXUP_ABSTRACT_VOICES[OUT_, SEC_, ITM_, VOI_]
                                    ]

feature {ANY}
   id: INTEGER

feature {MIXUP_ABSTRACT_INSTRUMENT}
   start_voices (a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]) is
      local
         map: AVL_DICTIONARY[VOI_, INTEGER]
         voices_: like root_voices
      do
         voices_ := new_voices(a_voice_id, voice_ids)
         create map.make
         if root_voices = Void then
            check
               a_voice_id = 0
               paths.is_empty
            end
            root_voices := voices_
         else
            check
               a_voice_id /= 0
               not paths.is_empty
            end
            map.copy(paths.top)
         end
         voices_.map_in(map)
         voices.push(voices_)
         paths.push(map)
      end

   end_voices (a_voice_id: INTEGER) is
      local
         voices_: like root_voices
      do
         voices_ := voices.top
         voices.pop
         paths.pop
         if a_voice_id /= 0 then
            check
               not paths.is_empty
            end
            voice(a_voice_id).add_item(voices_)
         end
      end

   set_dynamics (a_voice_id: INTEGER; dynamics, position: ABSTRACT_STRING) is
      do
         voice(a_voice_id).set_dynamics(dynamics, position)
      end

   set_note (a_voice_id: INTEGER; time: INTEGER_64; note: MIXUP_NOTE) is
      do
         voice(a_voice_id).set_note(time, note)
      end

   next_bar (a_voice_id: INTEGER; style: ABSTRACT_STRING) is
      do
         voice(a_voice_id).next_bar(style)
      end

   start_beam (a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         voice(a_voice_id).start_beam(xuplet_numerator, xuplet_denominator, text)
      end

   end_beam (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_beam
      end

   start_slur (a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         voice(a_voice_id).start_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_slur (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_slur
      end

   start_phrasing_slur (a_voice_id: INTEGER; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         voice(a_voice_id).start_phrasing_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_phrasing_slur (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_phrasing_slur
      end

   start_repeat (a_voice_id: INTEGER; volte: INTEGER_64) is
      do
         voice(a_voice_id).start_repeat(volte)
      end

   end_repeat (a_voice_id: INTEGER) is
      do
         voice(a_voice_id).end_repeat
      end

feature {MIXUP_ABSTRACT_INSTRUMENT}
   generate (context: MIXUP_CONTEXT; section: SEC_; generate_names: BOOLEAN) is
      require
         section /= Void
      local
         iter_lyrics: ZIP[AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64], INTEGER]
      do
         if root_voices /= Void then
            root_voices.generate(context, section)
         end

         if not lyrics.is_empty then
            create iter_lyrics.make(lyrics, 1 |..| lyrics.count)
            iter_lyrics.do_all(agent generate_lyrics(?, ?, context, section))
         end
      end

feature {}
   gather_lyrics (a_lyrics: TRAVERSABLE[MIXUP_SYLLABLE]; a_time: INTEGER_64) is
      local
         zip: ZIP[AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64], MIXUP_SYLLABLE]
      do
         ensure_lyrics_count(a_lyrics.count)
         create zip.make(lyrics, a_lyrics)
         zip.do_all(agent {AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]}.put({MIXUP_SYLLABLE}, a_time))
      end

   ensure_lyrics_count (a_count: INTEGER) is
      do
         from
         until
            lyrics.count >= a_count
         loop
            lyrics.add_last(create {AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]}.make)
         end
      ensure
         lyrics.count >= a_count
      end

   generate_lyrics (lyr: AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]; index: INTEGER; context: MIXUP_CONTEXT; section: SEC_) is
      require
         lyr /= Void
         index > 0
         section /= Void
      deferred
      end

feature {}
   make (a_id: like id; a_voice_ids: TRAVERSABLE[INTEGER]) is
      require
         a_id > 0
      do
         id := a_id
         create lyrics.make(0)
         lyrics_gatherer := agent gather_lyrics
         create voices.make
         create paths.make
      ensure
         id = a_id
      end

   lyrics: FAST_ARRAY[AVL_DICTIONARY[MIXUP_SYLLABLE, INTEGER_64]]
   lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]

   root_voices: VOS_
   voices: STACK[VOS_]
   paths: STACK[AVL_DICTIONARY[VOI_, INTEGER]]

   voice (a_voice_id: INTEGER): VOI_ is
      require
         not paths.is_empty
      do
         Result := paths.top.reference_at(a_voice_id)
      end

   new_voices (a_voice_id: INTEGER; voice_ids: TRAVERSABLE[INTEGER]): like root_voices is
      require
         voice_ids /= Void
      deferred
      ensure
         Result /= Void
      end

invariant
   id > 0
   lyrics /= Void
   voices /= Void
   paths /= Void
   voices.count = paths.count

end -- class MIXUP_ABSTRACT_STAFF
