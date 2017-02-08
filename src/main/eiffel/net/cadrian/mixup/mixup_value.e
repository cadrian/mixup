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
   frozen eval (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      do
         Result := eval_(a_commit_context, do_call)
         if Result /= Current and then Result /= Void then
            Result := Result.eval(a_commit_context, do_call)
         end
      end

   is_context: BOOLEAN is False
   as_context: MIXUP_CONTEXT
      require
         is_context
      do
         crash
      end

   is_callable: BOOLEAN
      deferred
      end

   call (a_source: MIXUP_SOURCE; a_commit_context: MIXUP_COMMIT_CONTEXT; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE
      require
         is_callable
         a_args /= Void
         a_source /= Void
         a_commit_context.context /= Void
      do
         crash
      end

   append_to (values: COLLECTION[MIXUP_VALUE])
      require
         values /= Void
      do
         values.add_last(Current)
      end

feature {}
   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      deferred
      end

end -- class MIXUP_VALUE
