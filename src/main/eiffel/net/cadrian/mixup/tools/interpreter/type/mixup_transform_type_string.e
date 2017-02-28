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
class MIXUP_TRANSFORM_TYPE_STRING

inherit
   MIXUP_TRANSFORM_TYPE_IMPL[STRING]

insert
   ARGUMENTS
      undefine
         is_equal
      end
   LOGGING
      undefine
         is_equal
      end
   MIXUP_TRANSFORM_TYPES
      undefine
         is_equal
      end

create {MIXUP_TRANSFORM_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN True

feature {MIXUP_TRANSFORM_INTERPRETER}
   value_of (image: MIXUP_TRANSFORM_NODE_IMAGE): MIXUP_TRANSFORM_VALUE
      local
         str: MIXUP_TRANSFORM_NODE_IMAGE_TYPED[STRING]
         arg: MIXUP_TRANSFORM_NODE_IMAGE_TYPED[INTEGER]
         res: MIXUP_TRANSFORM_VALUE_STRING
      do
         create res.make
         if str ?:= image then
            str ::= image
            res.set_value(str.value)
            Result := res
         elseif arg ?:= image then
            arg ::= image
            if argument_count > arg.value then
               res.set_value(argument(arg.value + 1))
               Result := res
            else
               set_error("argument #(1) not found" # image.image)
            end
         else
            set_error("internal error: invalid type")
         end
      end

feature {MIXUP_TRANSFORM_TYPES}
   init
      do
      end

end -- class MIXUP_TRANSFORM_TYPE_STRING
