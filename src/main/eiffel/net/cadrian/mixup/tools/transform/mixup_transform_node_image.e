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
deferred class MIXUP_TRANSFORM_NODE_IMAGE

inherit
   PARSER_IMAGE
      undefine
         out_in_tagged_out_memory
      end

insert
   MIXUP_TRANSFORM_NODE_TYPES
      undefine
         out_in_tagged_out_memory
      end

feature {ANY}
   image: STRING
   type: MIXUP_TRANSFORM_NODE_TYPE
   start_position, end_position: INTEGER

feature {}
   make (a_image: like image; a_start, a_end: INTEGER; a_type: like type)
      require
         a_image /= Void
         not a_image.is_empty
         a_start > 0
         a_end = a_start + a_image.count
         a_type /= Void implies valid_type(a_type)
      do
         image := a_image
         type := a_type
         start_position := a_start
         end_position := a_end
      ensure
         image = a_image
         type = a_type
         start_position = a_start
         end_position = a_end
      end

invariant
   image /= Void
   not image.is_empty
   end_position = start_position + image.count
   type /= Void implies valid_type(type)

end -- class MIXUP_TRANSFORM_NODE_IMAGE
