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
class MIXUP_LILYPOND_STAFF

insert
   MIXUP_LILYPOND_CONTEXT

create {ANY}
   make

feature {ANY}
   instrument: MIXUP_LILYPOND_INSTRUMENT
   id: INTEGER

feature {MIXUP_LILYPOND_INSTRUMENT}
   set_dynamics (a_voice_id: INTEGER; dynamics, position: ABSTRACT_STRING) is
      do
         voice(a_voice_id).set_dynamics(dynamics, position)
      end

   set_note (a_voice_id: INTEGER; note: MIXUP_NOTE) is
      do
         voice(a_voice_id).set_note(note)
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

feature {MIXUP_LILYPOND_INSTRUMENT}
   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM; generate_names: BOOLEAN) is
      require
         output.is_connected
      do
         output.put_line("         \new " + context_name + " = %"" + instrument.name.out + id.out + "%" <<")
         if generate_names then
            generate_context(context, output, instrument)
         end
         voices.do_all(agent {MIXUP_LILYPOND_VOICE}.generate(context, output))
         output.put_line("         >>")
      end

feature {}
   make (a_player: like player; a_instrument: like instrument; a_id: like id; a_voice_ids: TRAVERSABLE[INTEGER]; a_reference: MIXUP_NOTE_HEAD) is
      require
         a_player /= Void
         a_instrument /= Void
         a_id > 0
      do
         player := a_player
         instrument := a_instrument
         id := a_id
         create voices.make
         a_voice_ids.do_all(agent (a_id: INTEGER; a_reference: MIXUP_NOTE_HEAD) is
                               do
                                  voices.add(create {MIXUP_LILYPOND_VOICE}.make(Current, a_id, a_reference), a_id);
                               end(?, a_reference))
      ensure
         player = a_player
         instrument = a_instrument
         id = a_id
         voices.count = a_voice_ids.count
         a_voice_ids.for_all(agent (a_id: INTEGER): BOOLEAN is do Result := voices.fast_has(a_id) and then voices.fast_reference_at(a_id).id = a_id end)
      end

   player: MIXUP_LILYPOND_PLAYER
   voices: AVL_DICTIONARY[MIXUP_LILYPOND_VOICE, INTEGER]

   voice (a_voice_id: INTEGER): MIXUP_LILYPOND_VOICE is
      require
         voices.fast_has(a_voice_id)
      do
         Result := voices.fast_reference_at(a_voice_id)
      end

   context_name: FIXED_STRING is
      once
         Result := "Staff".intern
      end

invariant
   player /= Void
   instrument /= Void
   id > 0

end -- class MIXUP_LILYPOND_STAFF
