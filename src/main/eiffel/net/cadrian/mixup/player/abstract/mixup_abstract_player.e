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
deferred class MIXUP_ABSTRACT_PLAYER[OUT_ -> MIXUP_ABSTRACT_OUTPUT,
                                     SEC_ -> MIXUP_ABSTRACT_SECTION[OUT_],
                                     ITM_ -> MIXUP_ABSTRACT_ITEM[OUT_, SEC_],
                                     VOI_ -> MIXUP_ABSTRACT_VOICE[OUT_, SEC_, ITM_],
                                     VOS_ -> MIXUP_ABSTRACT_VOICES[OUT_, SEC_, ITM_, VOI_],
                                     STAF_ -> MIXUP_ABSTRACT_STAFF[OUT_, SEC_, ITM_, VOI_, VOS_],
                                     INST_ -> MIXUP_ABSTRACT_INSTRUMENT[OUT_, SEC_, ITM_, VOI_, VOS_, STAF_]
                                     ]

inherit
   MIXUP_CORE_PLAYER

feature {ANY}
   set_context (a_context: MIXUP_CONTEXT)
      do
         context := a_context
      ensure
         context = a_context
      end

feature {ANY}
   play_set_score (a_name: ABSTRACT_STRING)
      do
         push_section(once "score", a_name)
      end

   play_end_score
      do
         pop_section
      end

   play_set_book (a_name: ABSTRACT_STRING)
      do
         push_section(once "book", a_name)
      end

   play_end_book
      do
         pop_section
      end

   play_set_partitur (a_name: ABSTRACT_STRING)
      do
         push_section(once "partitur", a_name)
      end

   play_end_partitur
      do
         pop_section
      end

   play_set_instrument (a_name: ABSTRACT_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER])
      local
         inst_name: FIXED_STRING
         instrument: INST_
      do
         inst_name := a_name.intern
         instrument := new_instrument(inst_name, voice_staff_ids)
         log.info.put_line("adding instrument: " + a_name.out)
         instruments.add(instrument, inst_name)
      end

   play_start_voices (a_data: MIXUP_EVENT_DATA; voice_ids: TRAVERSABLE[INTEGER])
      do
         instruments.reference_at(a_data.instrument.name).start_voices(a_data.staff_id, a_data.voice_id, voice_ids)
      end

   play_end_voices (a_data: MIXUP_EVENT_DATA)
      do
         instruments.reference_at(a_data.instrument.name).end_voices(a_data.staff_id, a_data.voice_id)
      end

   play_set_dynamics (a_data: MIXUP_EVENT_DATA; dynamics, position: ABSTRACT_STRING; is_standard: BOOLEAN)
      do
         log.info.put_line(a_data.out + ": playing dynamics: " + dynamics.out)
         instruments.reference_at(a_data.instrument.name).set_dynamics(a_data.staff_id, a_data.voice_id, dynamics, position, is_standard)
      end

   play_set_note (a_data: MIXUP_EVENT_DATA; note: MIXUP_NOTE)
      do
         log.info.put_line(a_data.out + ": playing note: " + note.out)
         instruments.reference_at(a_data.instrument.name).set_note(a_data.staff_id, a_data.voice_id, a_data.start_time, note)
      end

   play_next_bar (a_data: MIXUP_EVENT_DATA; style: ABSTRACT_STRING)
      do
         log.info.put_line(a_data.out + ": playing bar")
         instruments.reference_at(a_data.instrument.name).next_bar(a_data.staff_id, a_data.voice_id, style)
      end

   play_skip_octave (a_data: MIXUP_EVENT_DATA; skip: INTEGER_8)
      do
         log.info.put_line(a_data.out + ": skip octave (" + skip.out + ")")
         instruments.reference_at(a_data.instrument.name).skip_octave(a_data.staff_id, a_data.voice_id, a_data.start_time, skip)
      end

   play_start_beam (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         log.info.put_line(a_data.out + ": starting beam")
         instruments.reference_at(a_data.instrument.name).start_beam(a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   play_end_beam (a_data: MIXUP_EVENT_DATA)
      do
         log.info.put_line(a_data.out + ": ending beam")
         instruments.reference_at(a_data.instrument.name).end_beam(a_data.staff_id, a_data.voice_id)
      end

   play_start_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         log.info.put_line(a_data.out + ": starting slur")
         instruments.reference_at(a_data.instrument.name).start_slur(a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   play_end_slur (a_data: MIXUP_EVENT_DATA)
      do
         log.info.put_line(a_data.out + ": ending slur")
         instruments.reference_at(a_data.instrument.name).end_slur(a_data.staff_id, a_data.voice_id)
      end

   play_start_phrasing_slur (a_data: MIXUP_EVENT_DATA; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING)
      do
         log.info.put_line(a_data.out + ": starting phrasing slur")
         instruments.reference_at(a_data.instrument.name).start_phrasing_slur(a_data.staff_id, a_data.voice_id, xuplet_numerator, xuplet_denominator, text)
      end

   play_end_phrasing_slur (a_data: MIXUP_EVENT_DATA)
      do
         log.info.put_line(a_data.out + ": ending phrasing slur")
         instruments.reference_at(a_data.instrument.name).end_phrasing_slur(a_data.staff_id, a_data.voice_id)
      end

   play_start_repeat (a_data: MIXUP_EVENT_DATA; volte: INTEGER_64)
      do
         log.info.put_line(a_data.out + ": starting repeat x" + volte.out)
         instruments.reference_at(a_data.instrument.name).start_repeat(a_data.staff_id, a_data.voice_id, volte)
      end

   play_end_repeat (a_data: MIXUP_EVENT_DATA)
      do
         log.info.put_line(a_data.out + ": ending repeat")
         instruments.reference_at(a_data.instrument.name).end_repeat(a_data.staff_id, a_data.voice_id)
      end

feature {} -- section files management
   push_section (section, a_name: ABSTRACT_STRING)
      require
         a_name /= Void
      do
         current_section := new_section(section, a_name)
      end

   pop_section
      local
         section: like current_section
         filename: STRING
         tfr: OUT_
      do
         -- agent below: should be {INST_} but SmartEiffel crashes (TODO fix SmartEiffel)
         instruments.do_all_items(agent {MIXUP_ABSTRACT_INSTRUMENT[MIXUP_ABSTRACT_OUTPUT,
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
                                                                                                                                  MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT]]]],
                                                                   MIXUP_ABSTRACT_STAFF[MIXUP_ABSTRACT_OUTPUT,
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
                                                                                                                                                       MIXUP_ABSTRACT_SECTION[MIXUP_ABSTRACT_OUTPUT]]]]]
                                                                   ]}.generate(current_section))
         instruments.clear_count

         section := current_section
         current_section := section.parent

         if managed_output then
            filename := build_filename(section.name)
            tfr := new_output(filename)
            if tfr.is_connected then
               section.generate(tfr)
               tfr.disconnect
            end
            if current_section = Void then
               call_tool(filename)
            end
         else
            section.generate(opus_output)
         end
      end

   build_filename (a_name: ABSTRACT_STRING): STRING
      deferred
      end

feature {}
   call_tool (filename: STRING)
      require
         filename /= Void
         managed_output
      deferred
      end

feature {}
   new_instrument (a_name: FIXED_STRING; voice_staff_ids: MAP[TRAVERSABLE[INTEGER], INTEGER]): INST_
      require
         a_name /= Void
      deferred
      ensure
         Result /= Void
         Result.name = a_name
      end

   new_section (section, a_name: ABSTRACT_STRING): SEC_
      require
         section /= Void
         a_name /= Void
      deferred
      ensure
         Result /= Void
      end

   new_output (a_filename: ABSTRACT_STRING): OUT_
      require
         a_filename /= Void
      deferred
      ensure
         Result.is_connected
      end

feature {}
   opus_name: FIXED_STRING
   opus_output: OUT_
   managed_output: BOOLEAN
   instruments: LINKED_HASHED_DICTIONARY[INST_, FIXED_STRING]
   context: MIXUP_CONTEXT

   current_section: SEC_

invariant
   instruments /= Void

end -- class MIXUP_ABSTRACT_PLAYER
