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
deferred class MIXUP_VALUE

inherit
   VISITABLE

feature {ANY}
   is_public: BOOLEAN
   is_constant: BOOLEAN

   set_public (enable: BOOLEAN) is
      do
         is_public := enable
      end

   set_constant (enable: BOOLEAN) is
      do
         is_constant := enable
      end

   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      do
         Result := Current
      end

   is_context: BOOLEAN is False
   as_context: MIXUP_CONTEXT is
      require
         is_context
      do
         crash
      end

   is_callable: BOOLEAN is False
   call (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      require
         is_callable
         a_context /= Void
         a_args /= Void
      do
         crash
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      require
         a_name /= Void
      deferred
      end

end -- class MIXUP_VALUE
