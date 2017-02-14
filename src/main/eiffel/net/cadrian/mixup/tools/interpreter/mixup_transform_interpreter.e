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
class MIXUP_TRANSFORM_INTERPRETER

inherit
   MIXUP_TRANSFORM_NODE_VISITOR

insert
   ARGUMENTS
   LOGGING

create {MIXUP_TRANSFORM}
   make

feature {ANY}
   error: ABSTRACT_STRING

feature {MIXUP_TRANSFORM_NODE_TERMINAL}
   visit_terminal (a_node: MIXUP_TRANSFORM_NODE_TERMINAL)
      do
      end

feature {MIXUP_TRANSFORM_NODE_NON_TERMINAL}
   visit_non_terminal (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      do
      end

feature {MIXUP_TRANSFORM_NODE_LIST}
   visit_list (a_node: MIXUP_TRANSFORM_NODE_LIST)
      do
      end

feature {}
   make (a_root: MIXUP_TRANSFORM_NODE)
      require
         a_root /= Void
      do
         a_root.accept(Current)
      end

end -- class MIXUP_TRANSFORM_INTERPRETER
