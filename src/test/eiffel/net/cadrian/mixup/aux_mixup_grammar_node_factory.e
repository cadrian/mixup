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
class AUX_MIXUP_GRAMMAR_NODE_FACTORY

inherit
   MIXUP_DEFAULT_NODE_FACTORY
      redefine
         make, list, non_terminal, terminal
      end

create {ANY}
   make

feature {ANY}
   created_nodes: TRAVERSABLE[MIXUP_NODE] is
      do
         Result := nodes
      end

feature {MIXUP_GRAMMAR}
   list (name: FIXED_STRING): MIXUP_LIST_NODE is
      do
         Result := Precursor(name)
         nodes.add_last(Result)
      end

   non_terminal (name: FIXED_STRING; names: TRAVERSABLE[FIXED_STRING]): MIXUP_NON_TERMINAL_NODE is
      do
         Result := Precursor(name, names)
         nodes.add_last(Result)
      end

   terminal (name: FIXED_STRING; image: MIXUP_IMAGE): MIXUP_TERMINAL_NODE is
      do
         Result := Precursor(name, image)
         nodes.add_last(Result)
      end

feature {}
   make is
      do
         Precursor
         create nodes.make(0)
      end

   nodes: FAST_ARRAY[MIXUP_NODE]

invariant
   nodes /= Void

end -- class AUX_MIXUP_GRAMMAR_NODE_FACTORY
