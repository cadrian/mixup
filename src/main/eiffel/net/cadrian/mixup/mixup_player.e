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
deferred class MIXUP_PLAYER
   -- Just a VISITOR with a fancy name (viz. an Acyclic Visitor)
   --
   -- See also MIXUP_CORE_PLAYER, MIXUP_EVENT

insert
   MIXUP_ERRORS

feature {ANY}
   name: FIXED_STRING
      deferred
      ensure
         exists: Result /= Void
         constant: Result = name
      end

   play (a_event: MIXUP_EVENT)
      require
         a_event /= Void
      do
         a_event.fire(Current)
      end

   native (a_def_source: MIXUP_SOURCE; a_context: MIXUP_NATIVE_CONTEXT; fn_name: STRING): MIXUP_VALUE
      require
         a_def_source /= Void
         fn_name /= Void
         a_context.is_ready
      deferred
      end

   set_context (a_context: MIXUP_CONTEXT)
      require
         a_context /= Void
      deferred
      end

end -- class MIXUP_PLAYER
