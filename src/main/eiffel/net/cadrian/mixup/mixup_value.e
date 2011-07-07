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
   MIXUP_EXPRESSION

feature {ANY}
   frozen eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN; bar_number: INTEGER): MIXUP_VALUE is
      do
         Result := eval_(a_context, a_player, do_call, bar_number)
         if Result /= Current and then Result /= Void then
            Result := Result.eval(a_context, a_player, do_call, bar_number)
         end
      end

   is_context: BOOLEAN is False
   as_context: MIXUP_CONTEXT is
      require
         is_context
      do
         crash
      end

   is_callable: BOOLEAN is
      deferred
      end

   call (a_source: MIXUP_SOURCE; a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]; a_bar_number: INTEGER): MIXUP_VALUE is
      require
         is_callable
         a_args /= Void
         a_source /= Void
      do
         crash
      end

   append_to (values: COLLECTION[MIXUP_VALUE]) is
      require
         values /= Void
      do
         values.add_last(Current)
      end

feature {}
   eval_ (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN; bar_number: INTEGER): MIXUP_VALUE is
      deferred
      end

end -- class MIXUP_VALUE
