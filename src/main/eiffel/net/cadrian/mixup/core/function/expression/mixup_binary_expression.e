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

insert
   MIXUP_ERRORS

feature {ANY}
   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      local
         left_val, right_val: MIXUP_VALUE
      do
         left_val := left.eval(a_context, a_player)
         right_val := right.eval(a_context, a_player)
         if left_val = Void then
            error("could not compute the left value")
         elseif right_val = Void then
            error("could not compute the right value")
         else
            Result := compute(left_val, right_val)
         end
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         left.as_name_in(a_name)
         a_name.extend(' ')
         a_name.append(operator)
         a_name.extend(' ')
         right.as_name_in(a_name)
      end

feature {}
   make (a_left: like left; a_right: like right) is
      require
         a_left /= Void
         a_right /= Void
      do
         left := a_left
         right := a_right
      ensure
         left = a_left
         right = a_right
      end

   compute (left_val, right_val: MIXUP_VALUE): MIXUP_VALUE is
      require
         left_val /= Void
         right_val /= Void
      deferred
      end

   operator: STRING is
      deferred
      ensure
         Result /= Void
      end

   left: MIXUP_EXPRESSION
   right: MIXUP_EXPRESSION

end -- class MIXUP_BINARY_EXPRESSION
