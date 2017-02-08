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
deferred class MIXUP_IMAGE

inherit
   PARSER_IMAGE
      redefine
         out_in_tagged_out_memory, is_equal
      end

feature {ANY}
   is_equal (other: like Current): BOOLEAN
         -- Redefined because SmartEiffel's default is_equal generates bad code in some strange situations
      do
         Result := position = other.position
            and then image.is_equal(other.image)
      end

feature {ANY}
   image: STRING
         -- the real image of the token

   blanks: STRING
         -- the leading blanks and comments (before the `image' itself)

   line: INTEGER
      do
         Result := position.line
      end

   column: INTEGER
      do
         Result := position.column
      end

   index: INTEGER
      do
         Result := position.index
      end

   out_in_tagged_out_memory
      do
         tagged_out_memory.append(image)
      end

feature {MIXUP_IMAGE}
   position: MIXUP_POSITION
         -- the position of the `image' (discarding the leading `blanks')

invariant
   image /= Void

end -- class MIXUP_IMAGE
