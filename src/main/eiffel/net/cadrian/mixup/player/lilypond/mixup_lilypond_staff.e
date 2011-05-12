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
   set_dynamics (dynamics, position: ABSTRACT_STRING) is
      do
         current_voice.set_dynamics(dynamics, position)
      end

   set_note (note: MIXUP_NOTE) is
      do
         current_voice.set_note(note)
      end

   next_bar (style: ABSTRACT_STRING) is
      do
         current_voice.next_bar(style)
      end

   start_beam (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         current_voice.start_beam(xuplet_numerator, xuplet_denominator, text)
      end

   end_beam is
      do
         current_voice.end_beam
      end

   start_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         current_voice.start_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_slur is
      do
         current_voice.end_slur
      end

   start_phrasing_slur (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         current_voice.start_phrasing_slur(xuplet_numerator, xuplet_denominator, text)
      end

   end_phrasing_slur is
      do
         current_voice.end_phrasing_slur
      end

   start_repeat (volte: INTEGER_64) is
      do
         current_voice.start_repeat(volte)
      end

   end_repeat is
      do
         current_voice.end_repeat
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
   make (a_player: like player; a_instrument: like instrument; a_id: like id; a_reference: MIXUP_NOTE_HEAD) is
      require
         a_player /= Void
         a_instrument /= Void
         a_id > 0
      do
         player := a_player
         instrument := a_instrument
         id := a_id
         create voices.with_capacity(4)
         voices.add_last(create {MIXUP_LILYPOND_VOICE}.make(Current, 1, a_reference));
      ensure
         player = a_player
         instrument = a_instrument
         id = a_id
      end

   player: MIXUP_LILYPOND_PLAYER
   voices: FAST_ARRAY[MIXUP_LILYPOND_VOICE]
   current_voice_index: INTEGER

   current_voice: MIXUP_LILYPOND_VOICE is
      do
         Result := voices.item(current_voice_index)
      end

   context_name: FIXED_STRING is
      once
         Result := "Staff".intern
      end

invariant
   player /= Void
   instrument /= Void
   id > 0
   voices.valid_index(current_voice_index)

end -- class MIXUP_LILYPOND_STAFF
