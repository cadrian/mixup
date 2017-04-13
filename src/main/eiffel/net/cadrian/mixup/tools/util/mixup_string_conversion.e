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
expanded class MIXUP_STRING_CONVERSION
   --
   -- Should be in Liberty Eiffel...
   --

insert
   MEMORY
      -- we need to pause GC during iconv because we access STRING
      -- internals via pointers

feature {ANY}
   Format_iso_8859_1: FIXED_STRING
      once
         Result := ("ISO_8859-1").intern
      end

   Format_iso_8859_15: FIXED_STRING
      once
         Result := (once "ISO_8859-15").intern
      end

   Format_utf_8: FIXED_STRING
         -- Is it really useful?
      once
         Result := (once "UTF-8").intern
      end

feature {ANY}
   utf8_to_iso (utf8: STRING; to_format: FIXED_STRING): STRING
      require
         utf8 /= Void
         to_format = Format_iso_8859_1 or else to_format = Format_iso_8859_15
      local
         res: POINTER; gc: BOOLEAN
      do
         gc := collecting
         if gc then
            collection_off
         end
         res := convert_chars(format_ptr(Format_utf_8, Option_none), format_ptr(to_format, Option_translit), utf8.to_external, utf8.count)
         if res.is_not_null then
            create Result.from_external(res)
         end
         if gc then
            collection_on
         end
      end

   iso_to_utf8 (string: STRING; from_format: FIXED_STRING): STRING
      require
         string /= Void
         from_format = Format_iso_8859_1 or else from_format = Format_iso_8859_15
      local
         res: POINTER; gc: BOOLEAN
      do
         gc := collecting
         if gc then
            collection_off
         end
         res := convert_chars(format_ptr(from_format, Option_none), format_ptr(Format_utf_8, Option_none), string.to_external, string.count)
         if res.is_not_null then
            create Result.from_external(res)
         end
         if gc then
            collection_on
         end
      end

feature {}
   Option_none: STRING ""
   Option_translit: STRING "//TRANSLIT"
   Option_ignore: STRING "//IGNORE"

   format_ptr (format, options: ABSTRACT_STRING): POINTER
      local
         fmt: STRING
      do
         create fmt.make_from_string("#(1)#(2)" # format # options)
         Result := fmt.to_external
      end

   convert_chars (source_format, target_format, source_data: POINTER; source_length: INTEGER): POINTER
      external "plug_in"
      alias "{
         location: "./plugins"
         module_name: "iconv"
         feature_name: "convert_chars"
         }"
      end

end -- class MIXUP_STRING_CONVERSION
