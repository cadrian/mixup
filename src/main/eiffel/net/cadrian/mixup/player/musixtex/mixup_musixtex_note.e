class MIXUP_MUSIXTEX_NOTE

create {MIXUP_MUSIXTEX_INSTRUMENT}
   chord, note, rest

feature {MIXUP_MUSIXTEX_INSTRUMENT}
   emit (context: MIXUP_MUSIXTEX_EMIT_CONTEXT) is
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
   note (a_name: FIXED_STRING; a_octave, a_duration: INTEGER_64) is
      do
         name := a_name
         octave := a_octave
         duration := a_duration
      end

   chord (a_name: FIXED_STRING; a_octave, a_duration: INTEGER_64) is
      do
         zero_spacing := True
         name := a_name
         octave := a_octave
         duration := a_duration
      end

   rest (a_name: FIXED_STRING; a_duration: INTEGER_64) is
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

end
