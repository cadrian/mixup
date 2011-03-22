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
deferred class MIXUP_VALUE_VISITOR

inherit
   VISITOR

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      require
         a_boolean /= Void
      deferred
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      require
         a_identifier /= Void
      deferred
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      require
         a_integer /= Void
      deferred
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      require
         a_real /= Void
      deferred
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      require
         a_string /= Void
      deferred
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      require
         a_function /= Void
      deferred
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      require
         a_function /= Void
      deferred
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      require
         a_music /= Void
      deferred
      end

feature {MIXUP_NO_VALUE}
   visit_no_value (a_no_value: MIXUP_NO_VALUE) is
      require
         a_no_value /= Void
      do
         -- default implementation does nothing because it is a very
         -- peculiar case
      end

end -- class MIXUP_VALUE_VISITOR
