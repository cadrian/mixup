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
deferred class MIXUP_LILYPOND_CONTEXT

insert
   MIXUP_ERRORS

feature {}
   context_name: FIXED_STRING is
      deferred
      end

   generate_context (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION; instrument: MIXUP_LILYPOND_INSTRUMENT) is
      require
         context_name /= Void
         instrument /= Void
      do
         generate_context_string(context, section, template_instrument_name, once "instrumentName", instrument.name)
         generate_context_string(context, section, template_instrument_abbrev, once "shortInstrumentName", instrument.name.first.out + ".")
      end

   get_string (context: MIXUP_CONTEXT; context_data_name: FIXED_STRING; default_value: ABSTRACT_STRING): FIXED_STRING is
      local
         val: MIXUP_VALUE; str: MIXUP_STRING
      do
         if context /= Void then
            val := context.lookup(context_data_name, player, True)
         end
         if val /= Void then
            if str ?:= val then
               str ::= val
               Result := str.value
            else
               error_at(val.source, context_data_name.out + " must be a string")
               val := Void
            end
         end
         if val = Void and then default_value /= Void then
            Result := default_value.intern
         end
      end

   generate_context_string (context: MIXUP_CONTEXT; section: MIXUP_LILYPOND_SECTION; context_data_name: FIXED_STRING; lilypond_variable_name, default_value: ABSTRACT_STRING) is
      require
         context_name /= Void
         section /= Void
      local
         str: FIXED_STRING
      do
         str := get_string(context, context_data_name, default_value)
         if str /= Void then
            section.set_body(once "\set ")
            section.set_body(context_name)
            section.set_body(once ".")
            section.set_body(lilypond_variable_name)
            section.set_body(once " = %"")
            section.set_body(str)
            section.set_body(once "%"%N")
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

   player: MIXUP_LILYPOND_PLAYER is
      deferred
      ensure
         Result /= Void
      end

end -- class MIXUP_LILYPOND_CONTEXT
