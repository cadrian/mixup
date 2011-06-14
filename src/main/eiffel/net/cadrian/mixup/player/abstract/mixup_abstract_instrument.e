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
deferred class MIXUP_ABSTRACT_INSTRUMENT[OUT_ -> MIXUP_ABSTRACT_OUTPUT,
                                         SEC_ -> MIXUP_ABSTRACT_SECTION[OUT_],
                                         ITM_ -> MIXUP_ABSTRACT_ITEM[OUT_, SEC_],
                                         VOI_ -> MIXUP_ABSTRACT_VOICE[OUT_, SEC_, ITM_],
                                         VOS_ -> MIXUP_ABSTRACT_VOICES[OUT_, SEC_, ITM_, VOI_,],
                                         STAF_ -> MIXUP_ABSTRACT_STAFF[OUT_, SEC_, ITM_, VOI_, VOS_]
                                         ]

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

feature {MIXUP_ABSTRACT_PLAYER}
   generate (section: SEC_) is
      require
         section /= Void
      do
         -- TODO: fix SmartEiffel, should be agent {STAF_}
         staffs.do_all(agent {MIXUP_ABSTRACT_STAFF[MIXUP_ABSTRACT_OUTPUT,
                                                   MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT],
                                                   MIXUP_ABSTRACT_ITEM[MIXUP_ABSTRACT_OUTPUT,
                                                                       MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT]],
                                                   MIXUP_ABSTRACT_VOICE[MIXUP_ABSTRACT_OUTPUT,
                                                                        MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT],
                                                                        MIXUP_ABSTRACT_ITEM[MIXUP_ABSTRACT_OUTPUT,
                                                                                            MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT]]],
                                                   MIXUP_ABSTRACT_VOICES[MIXUP_ABSTRACT_OUTPUT,
                                                                         MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT],
                                                                         MIXUP_ABSTRACT_ITEM[MIXUP_ABSTRACT_OUTPUT,
                                                                                             MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT]],
                                                                         MIXUP_ABSTRACT_VOICE[MIXUP_ABSTRACT_OUTPUT,
                                                                                              MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT],
                                                                                              MIXUP_ABSTRACT_ITEM[MIXUP_ABSTRACT_OUTPUT,
                                                                                                                  MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT]]]]
                                                   ]}.generate(context, section, False))
      end

feature {}
   make (a_context: like context; a_name: like name; a_voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]) is
      require
         a_context /= Void
         a_name /= Void
         a_voice_staff_ids /= Void
      do
         context := a_context
         name := a_name
         create staffs.make
         a_voice_staff_ids.do_all(agent (voice_ids: TRAVERSABLE[INTEGER]; id: INTEGER) is
                                     do
                                        staffs.add(new_staff(voice_ids, id), id);
                                     end)
      ensure
         context = a_context
         name = a_name
         staffs.count = a_voice_staff_ids.count
         a_voice_staff_ids.for_all(agent (a_voice_ids: TRAVERSABLE[INTEGER]; a_id: INTEGER): BOOLEAN is do Result := staffs.fast_has(a_id) and then staffs.fast_reference_at(a_id).id = a_id end)
      end

   new_staff (voice_ids: TRAVERSABLE[INTEGER]; id: INTEGER): STAF_ is
      require
         voice_ids /= Void
      deferred
      ensure
         Result.id = id
      end

   staffs: AVL_DICTIONARY[STAF_, INTEGER]
   context: MIXUP_CONTEXT

invariant
   context /= Void
   name /= Void
   staffs /= Void

end -- class MIXUP_ABSTRACT_INSTRUMENT
