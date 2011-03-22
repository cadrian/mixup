-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_MUSIXTEX_INSTRUMENT

create {MIXUP_MUSIXTEX_PLAYER}
   make

feature {ANY}
   name: FIXED_STRING
   index: INTEGER
   staffs: INTEGER

feature {MIXUP_MUSIXTEX_PLAYER}
   emit_instrument (output: OUTPUT_STREAM) is
      require
         output.is_connected
      do
         output.put_string(once "\setname{")
         output.put_integer(index)
         output.put_string(once "}{")
         output.put_string(name)
         output.put_line(once "}")
         output.put_string(once "\setstaffs{")
         output.put_integer(index)
         output.put_string(once "}{")
         output.put_integer(staffs)
         output.put_line(once "}")
      end

   emit (output: OUTPUT_STREAM) is
      require
         output /= Void
      local
         context: MIXUP_MUSIXTEX_EMIT_CONTEXT
      do
         create context.make(output)
         notes.do_all(agent {MIXUP_MUSIXTEX_NOTE}.emit(context))
         context.close
         notes.clear_count
      end

feature {}
   make (a_index: like index; a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      do
         name := a_name.intern
         index := a_index
         staffs := 1
         create notes.make(0)
      ensure
         name = a_name.intern
         index = a_index
         staffs = 1
      end

   notes: FAST_ARRAY[MIXUP_MUSIXTEX_NOTE]

end -- class MIXUP_MUSIXTEX_INSTRUMENT
