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
   args: TRAVERSABLE[MIXUP_VALUE]
   commit_context: MIXUP_COMMIT_CONTEXT

   context: MIXUP_CONTEXT
      do
         Result := commit_context.context
      end

   player: MIXUP_PLAYER
      do
         Result := commit_context.player
      end

   bar_number: INTEGER
      do
         Result := commit_context.bar_number
      end

   prepare (a_call_source: like call_source; a_commit_context: like commit_context; a_args: like args)
      require
         not is_ready
         a_call_source /= Void
         a_commit_context.context /= Void
         a_commit_context.player /= Void
         a_args /= Void
      do
         call_source := a_call_source
         args := a_args
         commit_context := a_commit_context
      ensure
         call_source = a_call_source
         args = a_args
         commit_context = a_commit_context
         is_ready
      end

   is_ready: BOOLEAN
      do
         Result := call_source /= Void and then context /= Void and then player /= Void and then args /= Void
      end

end -- class MIXUP_NATIVE_CONTEXT
