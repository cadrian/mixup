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
class MIXUP_TRANSFORM_NODE_IMAGE_UNTYPED

inherit
   MIXUP_TRANSFORM_NODE_IMAGE
      rename
         make as make_image
      end

create {MIXUP_TRANSFORM_GRAMMAR}
   make

feature {ANY}
   out_in_tagged_out_memory
      do
         tagged_out_memory.append("MIXUP_TRANSFORM_NODE_IMAGE_UNTYPED{#(1)}" # image)
      end

feature {}
   make (a_image: like image; a_start, a_end: INTEGER)
      do
         make_image(a_image, a_start, a_end, Void)
      end

invariant
   type = Void

end -- class MIXUP_TRANSFORM_NODE_IMAGE_UNTYPED
