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
class MIXUP_TRANSFORM_TYPE_ASSOCIATIVE

inherit
   MIXUP_TRANSFORM_TYPE
      rename
         make as make_type
      end

insert
   LOGGING
      undefine
         is_equal
      end

create {MIXUP_TRANSFORM_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN False

   index_type, value_type: MIXUP_TRANSFORM_TYPE

   field_type (field_name: STRING): MIXUP_TRANSFORM_TYPE
      do
      end

feature {MIXUP_TRANSFORM_TYPES}
   init
      do
      end

feature {}
   make (a_name: ABSTRACT_STRING; index, value: MIXUP_TRANSFORM_TYPE)
      require
         a_name /= Void
         index.is_comparable
         value /= Void
      do
         make_type(a_name)
         index_type := index
         value_type := value
      ensure
         name = a_name.intern
         index_type = index
         value_type = value
      end

invariant
   index_type.is_comparable
   value_type /= Void

end -- class MIXUP_TRANSFORM_TYPE_ASSOCIATIVE
