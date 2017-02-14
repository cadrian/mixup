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
expanded class MIXUP_TRANSFORM_NODE_TYPES
   --
   -- Known inference types
   --

feature {ANY}
   type_numeric: MIXUP_TRANSFORM_NODE_TYPE then type_numeric_
      ensure
         valid_type(Result)
      end

   type_string: MIXUP_TRANSFORM_NODE_TYPE then type_string_
      ensure
         valid_type(Result)
      end

   type_argument: MIXUP_TRANSFORM_NODE_TYPE then type_argument_
      ensure
         valid_type(Result)
      end

   type_boolean: MIXUP_TRANSFORM_NODE_TYPE then type_boolean_
      ensure
         valid_type(Result)
      end

   valid_type (a_type: MIXUP_TRANSFORM_NODE_TYPE): BOOLEAN
      require
         a_type /= Void
      do
         Result := types.fast_has(a_type)
      end

feature {}
   type_numeric_: MIXUP_TRANSFORM_NODE_TYPE
      once
         create Result.make("numeric")
      end

   type_string_: MIXUP_TRANSFORM_NODE_TYPE
      once
         create Result.make("string")
      end

   type_argument_: MIXUP_TRANSFORM_NODE_TYPE
      once
         create Result.make("argument")
      end

   type_boolean_: MIXUP_TRANSFORM_NODE_TYPE
      once
         create Result.make("boolean")
      end

   types: SET[MIXUP_TRANSFORM_NODE_TYPE]
      once
         Result := {HASHED_SET[MIXUP_TRANSFORM_NODE_TYPE] << type_numeric_, type_string_, type_argument_, type_boolean_ >> }
      end

end -- class MIXUP_TRANSFORM_NODE_TYPES
