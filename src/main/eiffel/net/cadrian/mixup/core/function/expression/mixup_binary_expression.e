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
deferred class MIXUP_BINARY_EXPRESSION

inherit
   MIXUP_EXPRESSION

feature {ANY}
   eval (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      local
         left_val, right_val: MIXUP_VALUE
      do
         left_val := left.eval(a_commit_context, True)
         right_val := right.eval(a_commit_context, True)
         if left_val = Void then
            error("could not compute the left value")
         elseif right_val = Void then
            error("could not compute the right value")
         else
            Result := compute(left_val, right_val)
         end
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING)
      do
         left.as_name_in(a_name)
         a_name.extend(' ')
         a_name.append(operator)
         a_name.extend(' ')
         right.as_name_in(a_name)
      end

feature {}
   make (a_source: like source; a_left: like left; a_right: like right)
      require
         a_source /= Void
         a_left /= Void
         a_right /= Void
      do
         source := a_source
         left := a_left
         right := a_right
      ensure
         source = a_source
         left = a_left
         right = a_right
      end

   compute (left_val, right_val: MIXUP_VALUE): MIXUP_VALUE
      require
         left_val /= Void
         right_val /= Void
      deferred
      end

   operator: STRING
      deferred
      ensure
         Result /= Void
      end

   left: MIXUP_EXPRESSION
   right: MIXUP_EXPRESSION

end -- class MIXUP_BINARY_EXPRESSION
