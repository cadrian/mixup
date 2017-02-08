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
class MIXUP_MUSIXTEX_NOTE

create {MIXUP_MUSIXTEX_INSTRUMENT}
   chord, note, rest

feature {MIXUP_MUSIXTEX_INSTRUMENT}
   emit (context: MIXUP_MUSIXTEX_EMIT_CONTEXT)
      require
         context /= Void
      do
         if octave = rest_octave then
            context.emit_rest(duration)
         else
            context.emit_duration(duration, zero_spacing)
            context.emit_octave(octave)
            context.emit_note(name)
         end
      end

feature {}
   note (a_name: FIXED_STRING; a_octave, a_duration: INTEGER_64)
      do
         name := a_name
         octave := a_octave
         duration := a_duration
      end

   chord (a_name: FIXED_STRING; a_octave, a_duration: INTEGER_64)
      do
         zero_spacing := True
         name := a_name
         octave := a_octave
         duration := a_duration
      end

   rest (a_name: FIXED_STRING; a_duration: INTEGER_64)
      do
         name := a_name
         octave := rest_octave
         duration := a_duration
      end

   rest_octave: INTEGER_64 is -1000

   zero_spacing: BOOLEAN
   name: FIXED_STRING
   octave: INTEGER_64
   duration: INTEGER_64

end -- class MIXUP_MUSIXTEX_NOTE
