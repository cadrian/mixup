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
class TEST_MIDI_OUTPUT_STREAM

insert
   EIFFELTEST_TOOLS
   LOGGING

create {}
   make

feature {}
   stream: AUX_MIXUP_MOCK_MIDI_OUTPUT

   make is
      do
         create stream.make

         stream.put_variable(0x0000000a)
         assert_stream("%/10/")

         stream.put_variable(0x0000007f)
         assert_stream("%/127/")

         stream.put_variable(0x00000080)
         assert_stream("%/129/%/0/")

         stream.put_variable(0x000000ff)
         assert_stream("%/129/%/127/")

         stream.put_variable(0x00008000)
         assert_stream("%/130/%/128/%/0/")
      end

   assert_stream (ref: STRING) is
      local
         string: STRING
      do
         string := ""
         stream.append_in(string)
         assert(string.is_equal(ref))
         stream.clear_count
      end

end -- class TEST_MIDI_OUTPUT_STREAM
