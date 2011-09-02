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
deferred class MIXUP_ABSTRACT_VOICE[OUT_ -> MIXUP_ABSTRACT_OUTPUT,
                                    SEC_ -> MIXUP_ABSTRACT_SECTION[OUT_],
                                    ITM_ -> MIXUP_ABSTRACT_ITEM[OUT_, SEC_]
                                    ]

feature {ANY}
   id: INTEGER

feature {MIXUP_ABSTRACT_STAFF}
   add_item (a_item: ITM_) is
      require
         a_item /= Void
      deferred
      ensure
         items.count = old items.count + 1
         items.last = a_item
      end

   set_dynamics (a_dynamics, position: ABSTRACT_STRING; is_standard: BOOLEAN) is
      deferred
      end

   set_note (a_time: INTEGER_64; a_note: MIXUP_NOTE) is
      deferred
      end

   next_bar (style: ABSTRACT_STRING) is
      deferred
      end

   skip_octave (time: INTEGER_64; skip: INTEGER_8) is
      deferred
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      deferred
      end

   end_beam is
      deferred
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      deferred
      end

   end_slur is
      deferred
      end

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      deferred
      end

   end_phrasing_slur is
      deferred
      end

   start_repeat (volte: INTEGER_64) is
      deferred
      end

   end_repeat is
      deferred
      end

feature {MIXUP_ABSTRACT_VOICES}
   generate (context: MIXUP_CONTEXT; section: SEC_) is
      require
         section /= Void
      do
         -- TODO: fix SmartEiffel bug; should be agent {ITM_}
         items.do_all(agent {MIXUP_ABSTRACT_ITEM[MIXUP_ABSTRACT_OUTPUT, MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT]]}.generate(context, section))
      end

feature {}
   make (a_id: like id; a_lyrics_gatherer: like lyrics_gatherer) is
      require
         a_id > 0
         a_lyrics_gatherer /= Void
      do
         id := a_id
         lyrics_gatherer := a_lyrics_gatherer
         create items.make(0)
      ensure
         id = a_id
         lyrics_gatherer = a_lyrics_gatherer
      end

   items: FAST_ARRAY[ITM_]
   lyrics_gatherer: PROCEDURE[TUPLE[TRAVERSABLE[MIXUP_SYLLABLE], INTEGER_64]]

invariant
   id > 0
   lyrics_gatherer /= Void
   items /= Void

end -- class MIXUP_ABSTRACT_VOICE
