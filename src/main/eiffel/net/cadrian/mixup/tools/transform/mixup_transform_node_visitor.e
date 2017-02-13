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
deferred class MIXUP_TRANSFORM_NODE_VISITOR

inherit
   VISITOR

feature {MIXUP_TRANSFORM_NODE_TERMINAL}
   visit_terminal (a_node: MIXUP_TRANSFORM_NODE_TERMINAL)
      require
         a_node /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_NODE_NON_TERMINAL}
   visit_non_terminal (a_node: MIXUP_TRANSFORM_NODE_NON_TERMINAL)
      require
         a_node /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_NODE_LIST}
   visit_list (a_node: MIXUP_TRANSFORM_NODE_LIST)
      require
         a_node /= Void
      deferred
      end

end -- class MIXUP_TRANSFORM_NODE_VISITOR
