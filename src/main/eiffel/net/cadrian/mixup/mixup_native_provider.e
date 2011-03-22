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
deferred class MIXUP_NATIVE_PROVIDER

feature {ANY}
   item (name: STRING): FUNCTION[TUPLE[MIXUP_CONTEXT, MIXUP_PLAYER, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE] is
      require
         name /= Void
      deferred
      ensure
         Result /= Void
      end

end -- class MIXUP_NATIVE_PROVIDER
