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
class TEST_STRING_CONVERSION

insert
   EIFFELTEST_TOOLS
   MIXUP_STRING_CONVERSION

create {}
   make

feature {}
   make
      local
         utf, str, utf2: STRING
      do
         utf := "áéèô"
         assert(utf.count = 8)
         --io.put_line(utf)
         str := utf8_to_iso(utf, Format_iso_8859_15)
         assert(str.count = 4);
         assert(str.item(1).code = 0x00e1)
         assert(str.item(2).code = 0x00e9)
         assert(str.item(3).code = 0x00e8)
         assert(str.item(4).code = 0x00f4)
         --str.for_each(agent (c: CHARACTER) do io.put_line("#(1) (#(2))" # &c # c.code.to_hexadecimal) end (?))
         utf2 := iso_to_utf8(str, Format_iso_8859_15)
         --io.put_line("'#(1)' (#(2))" # utf2 # &utf2.count)
         assert(utf2.is_equal(utf))
      end

end -- class TEST_STRING_CONVERSION
