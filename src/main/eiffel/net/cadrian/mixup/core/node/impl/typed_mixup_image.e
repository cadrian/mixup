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
class TYPED_MIXUP_IMAGE[E_]

inherit
   MIXUP_IMAGE

create {MIXUP_GRAMMAR}
   make

feature {ANY}
   decoded: E_

feature {}
   make (a_image: like image; a_decoded: like decoded; a_blanks: like blanks; a_position: like position) is
      require
         a_image /= Void
         a_decoded /= Void
      do
         image := a_image
         decoded := a_decoded
         blanks := a_blanks
         position := a_position
      ensure
         image = a_image
         decoded = a_decoded
         blanks = a_blanks
         position = a_position
      end

invariant
   decoded /= Void

end -- class TYPED_MIXUP_IMAGE
