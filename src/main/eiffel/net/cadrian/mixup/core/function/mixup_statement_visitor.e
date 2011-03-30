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
deferred class MIXUP_STATEMENT_VISITOR

inherit
   VISITOR

feature {MIXUP_ASSIGNMENT}
   visit_assignment (a_assignment: MIXUP_ASSIGNMENT) is
      require
         a_assignment /= Void
      deferred
      end

feature {MIXUP_EXPRESSION_AS_STATEMENT}
   visit_expression_as_statement (a_expression_as_statement: MIXUP_EXPRESSION_AS_STATEMENT) is
      require
         a_expression_as_statement /= Void
      deferred
      end

feature {MIXUP_IF_THEN_ELSE}
   visit_if_then_else (a_if_then_else: MIXUP_IF_THEN_ELSE) is
      require
         a_if_then_else /= Void
      deferred
      end

feature {MIXUP_LOOP}
   visit_loop (a_loop: MIXUP_LOOP) is
      require
         a_loop /= Void
      deferred
      end

feature {MIXUP_RESULT_ASSIGNMENT}
   visit_result_assignment (a_result_assignment: MIXUP_RESULT_ASSIGNMENT) is
      require
         a_result_assignment /= Void
      deferred
      end

feature {MIXUP_YIELD}
   visit_yield (a_yield: MIXUP_YIELD) is
      require
         a_yield /= Void
      deferred
      end

end -- class MIXUP_STATEMENT_VISITOR
