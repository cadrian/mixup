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
class AUX_MIXUP_MOCK_EVENT

insert
   ANY
      redefine
         is_equal, out_in_tagged_out_memory
      end

create {AUX_MIXUP_MOCK_PLAYER_EVENTS}
   make

feature {ANY}
   name: FIXED_STRING
   values: TUPLE

   is_equal (other: like Current): BOOLEAN is
      do
         Result := name.is_equal(other.name) and then values.is_equal(other.values)
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.extend('{')
         tagged_out_memory.append(name)
         tagged_out_memory.extend(':')
         values.out_in_tagged_out_memory
         tagged_out_memory.extend('}')
      end

feature {}
   make (a_name: like name; a_values: like values) is
      require
         a_name /= Void
         a_values /= Void
      do
         name := a_name
         values := a_values
      ensure
         name = a_name
         values = a_values
      end

invariant
   name /= Void
   values /= Void

end -- class AUX_MIXUP_MOCK_EVENT
