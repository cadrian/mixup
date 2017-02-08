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
class MIXUP_VALUE_IN_CONTEXT

insert
   ANY
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   value: MIXUP_VALUE
   is_const: BOOLEAN
   is_public: BOOLEAN

   out_in_tagged_out_memory
      do
         tagged_out_memory.extend('[')
         value.out_in_tagged_out_memory
         if is_const then
            tagged_out_memory.append(once ", const")
         end
         if is_public then
            tagged_out_memory.append(once ", public")
         end
         tagged_out_memory.extend(']')
      end

feature {}
   make (a_value: like value; a_const: like is_const; a_public: like is_public)
      require
         a_value /= Void
      do
         value := a_value
         is_const := a_const
         is_public := a_public
      ensure
         value = a_value
         is_const = a_const
         is_public = a_public
      end

end -- class MIXUP_VALUE_IN_CONTEXT
