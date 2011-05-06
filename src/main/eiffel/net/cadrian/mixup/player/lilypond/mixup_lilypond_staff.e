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
         current_voice.start_beam(xuplet_numerator, xuplet_numerator, text)
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

   start_tie (xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         current_voice.start_tie(xuplet_numerator, xuplet_denominator, text)
      end

   end_tie is
      do
         current_voice.end_tie
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
   generate (context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      require
         output.is_connected
      do
         output.put_line("         \new Staff = %"" + instrument.name.out + id.out + "%" <<")
         generate_context(context, output)
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

   generate_context (context: MIXUP_CONTEXT; output: OUTPUT_STREAM) is
      do
         generate_context_string(context, output, template_instrument_name, once "Staff.instrumentName", instrument.name.out)
         generate_context_string(context, output, template_instrument_abbrev, once "Staff.shortInstrumentName", instrument.name.first.out + ".")
      end

   generate_context_string (context: MIXUP_CONTEXT; output: OUTPUT_STREAM; context_data_name: FIXED_STRING; lilypond_variable_name, default_value: STRING) is
      local
         val: MIXUP_VALUE; str: MIXUP_STRING
      do
         if context /= Void then
            val := context.lookup(context_data_name, player, True)
         end
         if val /= Void and then (str ?:= val) then
            str ::= val
            output.put_line("            \set " + lilypond_variable_name + " = %"" + str.value.out + "%"")
         elseif default_value /= Void then
            output.put_line("            \set " + lilypond_variable_name + " = %"" + default_value + "%"")
         end
      end

   template_instrument_name: FIXED_STRING is
      once
         Result := "template.instrument_name".intern
      end

   template_instrument_abbrev: FIXED_STRING is
      once
         Result := "template.instrument_abbrev".intern
      end

invariant
   player /= Void
   instrument /= Void
   id > 0
   voices.valid_index(current_voice_index)

end -- class MIXUP_LILYPOND_STAFF
