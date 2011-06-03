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
deferred class MIXUP_EXPRESSION

inherit
   VISITABLE
      redefine
         out_in_tagged_out_memory
      end

insert
   MIXUP_ERRORS
      redefine
         out_in_tagged_out_memory
      end

feature {ANY}
   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN): MIXUP_VALUE is
      require
         a_context /= Void
         a_player /= Void
      deferred
      end

   out_in_tagged_out_memory is
      do
         as_name_in(tagged_out_memory)
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      require
         a_name /= Void
      deferred
      end

invariant
   source /= Void

end -- class MIXUP_EXPRESSION
