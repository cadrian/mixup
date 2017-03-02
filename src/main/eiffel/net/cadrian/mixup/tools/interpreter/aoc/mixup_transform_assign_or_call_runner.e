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
deferred class MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER

feature {MIXUP_TRANSFORM_INTERPRETER}
   error: ABSTRACT_STRING

   set_target (a_target: MIXUP_TRANSFORM_VALUE)
      require
         is_new
         error = Void
         a_target /= Void
      do
         expression_string.add_last(create {MIXUP_TRANSFORM_AOC_TARGET}.make(a_target))
      end

   set_field (a_field: STRING)
      require
         not is_new
         error = Void
         a_field /= Void
      do
         expression_string.add_last(create {MIXUP_TRANSFORM_AOC_FIELD}.make(a_field))
      end

   set_index (a_index: MIXUP_TRANSFORM_VALUE)
      require
         not is_new
         error = Void
         a_index /= Void
      do
         expression_string.add_last(create {MIXUP_TRANSFORM_AOC_INDEX}.make(a_index))
      end

   run
      deferred
      end

   is_new: BOOLEAN then expression_string.is_empty
      end

feature {}
   expression_string: FAST_ARRAY[MIXUP_TRANSFORM_AOC_EXPRESSION]

invariant
   expression_string /= Void

end -- class MIXUP_TRANSFORM_ASSIGN_OR_CALL_RUNNER
