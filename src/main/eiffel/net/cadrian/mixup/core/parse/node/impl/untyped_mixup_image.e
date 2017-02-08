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
class UNTYPED_MIXUP_IMAGE

inherit
   MIXUP_IMAGE

create {MIXUP_GRAMMAR}
   make

feature {}
   make (a_image: like image; a_blanks: like blanks; a_position: like position)
      require
         a_image /= Void
      do
         image := a_image
         blanks := a_blanks
         position := a_position
      ensure
         image = a_image
         blanks = a_blanks
         position = a_position
      end

end -- class UNTYPED_MIXUP_IMAGE
