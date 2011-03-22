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
deferred class MIXUP_NODE_FACTORY

feature {MIXUP_GRAMMAR}
   list (name: FIXED_STRING): MIXUP_LIST_NODE is
      deferred
      ensure
         Result.name = name
      end

   non_terminal (name: FIXED_STRING; names: TRAVERSABLE[FIXED_STRING]): MIXUP_NON_TERMINAL_NODE is
      require
         not name.is_empty
         names /= Void
      deferred
      ensure
         Result.name = name
      end

   terminal (name: FIXED_STRING; image: MIXUP_IMAGE): MIXUP_TERMINAL_NODE is
      require
         not name.is_empty
         image /= Void
      deferred
      ensure
         Result.name = name
         Result.image.is_equal(image)
      end

end -- class MIXUP_NODE_FACTORY
