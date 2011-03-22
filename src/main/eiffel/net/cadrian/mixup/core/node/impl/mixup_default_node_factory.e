-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_DEFAULT_NODE_FACTORY

inherit
   MIXUP_NODE_FACTORY

create {ANY}
   make

feature {MIXUP_GRAMMAR}
   list (name: FIXED_STRING): MIXUP_LIST_NODE is
      do
         create {MIXUP_LIST_NODE_IMPL} Result.make(name)
      end

   non_terminal (name: FIXED_STRING; names: TRAVERSABLE[FIXED_STRING]): MIXUP_NON_TERMINAL_NODE is
      do
         create {MIXUP_NON_TERMINAL_NODE_IMPL} Result.make(name, names)
      end

   terminal (name: FIXED_STRING; image: MIXUP_IMAGE): MIXUP_TERMINAL_NODE is
      do
         create {MIXUP_TERMINAL_NODE_IMPL} Result.make(name, image)
      end

feature {}
   make is
      do
      end

end -- class MIXUP_DEFAULT_NODE_FACTORY
