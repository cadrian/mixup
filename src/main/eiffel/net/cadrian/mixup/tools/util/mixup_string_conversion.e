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

feature {ANY}
   Format_iso_8859_1: POINTER
      once
         Result := (once "ISO_8859-1").to_external
      end

   Format_iso_8859_15: POINTER
      once
         Result := (once "ISO_8859-15").to_external
      end

   Format_utf_8: POINTER
         -- Is it really useful?
      once
         Result := (once "UTF-8").to_external
      end

   format (desc: STRING): POINTER
      require
         desc /= Void
      local
         d: STRING
      do
         d := once ""
         d.copy(desc)
         d.to_upper
         inspect
            d
         when "ISO-8869-1" then
            Result := Format_iso_8859_1
         when "ISO-8869-15" then
            Result := Format_iso_8859_15
         when "UTF8", "UTF_8", "UTF-8" then
            Result := Format_utf_8
         else
            -- unknown
         end
      end

feature {ANY}
   utf8_to_iso (utf8: STRING; to_format: POINTER): STRING
      require
         utf8 /= Void
         to_format = Format_iso_8859_1 or else to_format = Format_iso_8859_15
      local
         res: POINTER
      do
         res := convert_chars(Format_utf_8, to_format, utf8.to_external, utf8.count)
         if res.is_not_null then
            create Result.from_external(res)
         end
      end

   iso_to_utf8 (string: STRING; from_format: POINTER): STRING
      require
         string /= Void
         from_format = Format_iso_8859_1 or else from_format = Format_iso_8859_15
      local
         res: POINTER
      do
         res := convert_chars(from_format, Format_utf_8, string.to_external, string.count)
         if res.is_not_null then
            create Result.from_external(res)
         end
      end

feature {}
   convert_chars (source_format, target_format, source_data: POINTER; source_length: INTEGER): POINTER
      external "plug_in"
      alias "{
         location: "./plugins"
         module_name: "iconv"
         feature_name: "convert_chars"
         }"
      end

end -- class MIXUP_STRING_CONVERSION
