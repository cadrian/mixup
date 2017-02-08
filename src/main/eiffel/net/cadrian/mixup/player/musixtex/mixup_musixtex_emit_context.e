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
class MIXUP_MUSIXTEX_EMIT_CONTEXT

insert
   MIXUP_NOTE_DURATIONS

create {MIXUP_MUSIXTEX_INSTRUMENT}
   make

feature {ANY}
   emit_rest (duration: INTEGER_64)
      do
         close_duration
         output.put_character('\')
         output.put_string(rests.at(duration))
      end

   emit_duration (duration: INTEGER_64; zero_spacing: BOOLEAN)
      local
         dur: like last_duration
      do
         if zero_spacing then
            if duration >= duration_2 then
               dur := white_note_head
            else
               dur := black_note_head
            end
         else
            dur := durations.at(duration)
         end
         if dur /= last_duration then
            close_duration
            output.put_character('\')
            output.put_string(dur)
            output.put_character('{')
            last_duration := dur
         end
      end

   emit_octave (octave: INTEGER_64)
      do
         if octave < last_octave then
            emit_quotes(octave, last_octave, '`')
         elseif octave > last_octave then
            emit_quotes(last_octave, octave, '%'')
         end
         last_octave := octave
      end

   emit_note (note: FIXED_STRING)
      do
         if note.has_suffix(once "es") then
            output.put_string(once "\fl ")
         elseif note.has_suffix(once "is") then
            output.put_string(once "\sh ")
         end
         output.put_character(note.first)
      end

   close
      do
         close_duration
      end

feature {}
   make (a_output: like output)
      require
         a_output /= Void
      do
         output := a_output
         last_octave := -1000
         last_duration := Void
      ensure
         output = a_output
      end

   output: OUTPUT_STREAM
   last_octave: INTEGER_64
   last_duration: FIXED_STRING

   emit_quotes (o1, o2: INTEGER_64; quote: CHARACTER)
      require
         o1 < o2
      local
         i: INTEGER_64
      do
         from
            i := o1
         until
            i = o2
         loop
            output.put_character(quote)
            i := i + 1
         end
      end

   close_duration
      do
         if last_duration /= Void then
            output.put_character('}')
            last_duration := Void
         end
      end

   white_note_head: FIXED_STRING
      once
         Result := "zh".intern
      end

   black_note_head: FIXED_STRING
      once
         Result := "zq".intern
      end

   durations: DICTIONARY[FIXED_STRING, INTEGER_64]
      once
         Result := {HASHED_DICTIONARY[FIXED_STRING, INTEGER_64]
         <<
           "cccca".intern,   duration_64  ;
           "ccccap".intern,  duration_64p ;
           "ccccapp".intern, duration_64pp;
           "ccca".intern,    duration_32  ;
           "cccap".intern,   duration_32p ;
           "cccapp".intern,  duration_32pp;
           "cca".intern,     duration_16  ;
           "ccap".intern,    duration_16p ;
           "ccapp".intern,   duration_16pp;
           "ca".intern,      duration_8   ;
           "cap".intern,     duration_8p  ;
           "capp".intern,    duration_8pp ;
           "qa".intern,      duration_4   ;
           "qap".intern,     duration_4p  ;
           "qapp".intern,    duration_4pp ;
           "ha".intern,      duration_2   ;
           "hap".intern,     duration_2p  ;
           "happ".intern,    duration_2pp ;
           "wh".intern,      duration_1   ;
           "whp".intern,     duration_1p  ;
           "whpp".intern,    duration_1pp ;
           >>};
      end

   rests: DICTIONARY[FIXED_STRING, INTEGER_64]
      once
         Result := {HASHED_DICTIONARY[FIXED_STRING, INTEGER_64]
         <<
           "qqs".intern,      duration_64  ;
           "qqsp".intern,     duration_64p ;
           "qqspp".intern,    duration_64pp;
           "hs".intern,       duration_32  ;
           "hsp".intern,      duration_32p ;
           "hspp".intern,     duration_32pp;
           "qs".intern,       duration_16  ;
           "qsp".intern,      duration_16p ;
           "qspp".intern,     duration_16pp;
           "ds".intern,       duration_8   ;
           "dsp".intern,      duration_8p  ;
           "dspp".intern,     duration_8pp ;
           "qp".intern,       duration_4   ;
           "qpp".intern,      duration_4p  ;
           "qppp".intern,     duration_4pp ;
           "hpause".intern,   duration_2   ;
           "hpausep".intern,  duration_2p  ;
           "hpausepp".intern, duration_2pp ;
           "pause".intern,    duration_1   ;
           "pausep".intern,   duration_1p  ;
           "pausepp".intern,  duration_1pp ;
           >>};
      end

invariant
   output /= Void

end -- class MIXUP_MUSIXTEX_EMIT_CONTEXT
