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
deferred class MIXUP_ABSTRACT_ITEM[OUT_ -> MIXUP_ABSTRACT_OUTPUT,
                                   SEC_ -> MIXUP_ABSTRACT_SECTION[OUT_]]

feature {ANY}
   generate (context: MIXUP_CONTEXT; section: SEC_) is
      require
         section /= Void
      deferred
      end

end -- class MIXUP_ABSTRACT_ITEM
