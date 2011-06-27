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
expanded class MIXUP_NATIVE_CONTEXT

feature {ANY}
   call_source: MIXUP_SOURCE
   context: MIXUP_CONTEXT
   player: MIXUP_PLAYER
   args: TRAVERSABLE[MIXUP_VALUE]

   prepare (a_call_source: like call_source; a_context: like context; a_player: like player; a_args: like args) is
      require
         not is_ready

         a_call_source /= Void
         a_context /= Void
         a_player /= Void
         a_args /= Void
      do
         call_source := a_call_source
         context := a_context
         player := a_player
         args := a_args
      ensure
         call_source = a_call_source
         context = a_context
         player = a_player
         args = a_args

         is_ready
      end

   is_ready: BOOLEAN is
      do
         Result := call_source /= Void and then context /= Void and then player /= Void and then args /= Void
      end

end -- class MIXUP_NATIVE_CONTEXT
