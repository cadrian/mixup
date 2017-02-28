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
deferred class MIXUP_TRANSFORM_NODE

inherit
   VISITABLE

feature {ANY}
   parent: MIXUP_TRANSFORM_NODE
   name: FIXED_STRING

   start_position: INTEGER
      require
         has_position
      deferred
      ensure
         Result > 0
      end

   end_position: INTEGER
      require
         has_position
      deferred
      ensure
         Result > 0
      end

   has_position: BOOLEAN
      require
         is_valid
      deferred
      end

   is_valid: BOOLEAN
      deferred
      end

   type: MIXUP_TRANSFORM_TYPE
      deferred
      end

   set_type (a_type: like type)
      require
         type = Void
      deferred
      ensure
         type = a_type
      end

feature {MIXUP_TRANSFORM_NODE}
   set_parent (a_parent: like parent)
      do
         parent := a_parent
      ensure
         parent = a_parent
      end

invariant
   (is_valid and then has_position) implies start_position > 0
   (is_valid and then has_position) implies end_position >= start_position
   name /= Void
   not name.is_empty

end -- class MIXUP_TRANSFORM_NODE
