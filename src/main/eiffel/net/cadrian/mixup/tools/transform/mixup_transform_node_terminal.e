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
class MIXUP_TRANSFORM_NODE_TERMINAL

inherit
   MIXUP_TRANSFORM_NODE

create {MIXUP_TRANSFORM_GRAMMAR}
   make

feature {ANY}
   start_position: INTEGER then image.start_position
      ensure
         definition: Result = image.start_position
      end

   end_position: INTEGER then image.end_position
      ensure
         definition: Result = image.end_position
      end

   image: MIXUP_TRANSFORM_NODE_IMAGE

   is_valid: BOOLEAN True

feature {ANY}
   accept (visitor: VISITOR)
      local
         v: MIXUP_TRANSFORM_NODE_VISITOR
      do
         v ::= visitor
         v.visit_terminal(Current)
      end

feature {}
   make (a_name: like name; a_image: like image)
      require
         a_name /= Void
         a_image /= Void
      do
         name := a_name
         image := a_image
      ensure
         name = a_name
         image = a_image
      end

invariant
   image /= Void

end -- class MIXUP_TRANSFORM_NODE_TERMINAL
