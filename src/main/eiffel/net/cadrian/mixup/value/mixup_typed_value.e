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
deferred class MIXUP_TYPED_VALUE[E_]

inherit
   MIXUP_VALUE
      redefine
         out_in_tagged_out_memory, is_equal
      end

insert
   SAFE_EQUAL[E_]
      redefine
         out_in_tagged_out_memory, is_equal
      end

feature {ANY}
   value: E_

   is_callable: BOOLEAN is False

   out_in_tagged_out_memory is
      do
         if value = Void then
            tagged_out_memory.append(once "Void")
         else
            value.out_in_tagged_out_memory
         end
      end

   is_equal (other: like Current): BOOLEAN is
      do
         Result := safe_equal(value, other.value)
      end

feature {}
   make (a_source: like source; a_value: like value) is
      require
         a_source /= Void
      do
         source := a_source
         value := a_value
      ensure
         source = a_source
         value = a_value
      end

   eval_ (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN; bar_number: INTEGER): MIXUP_VALUE is
      do
         Result := Current
      end

end -- class MIXUP_TYPED_VALUE
