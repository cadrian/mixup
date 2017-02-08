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
deferred class MIXUP_EXPRESSION_VISITOR

inherit
   VISITOR

feature {MIXUP_ADD}
   visit_add (a_add: MIXUP_ADD)
      require
         a_add /= Void
      deferred
      end

feature {MIXUP_AND}
   visit_and (a_and: MIXUP_AND)
      require
         a_and /= Void
      deferred
      end

feature {MIXUP_DIVIDE}
   visit_divide (a_divide: MIXUP_DIVIDE)
      require
         a_divide /= Void
      deferred
      end

feature {MIXUP_EQ}
   visit_eq (a_eq: MIXUP_EQ)
      require
         a_eq /= Void
      deferred
      end

feature {MIXUP_GE}
   visit_ge (a_ge: MIXUP_GE)
      require
         a_ge /= Void
      deferred
      end

feature {MIXUP_GT}
   visit_gt (a_gt: MIXUP_GT)
      require
         a_gt /= Void
      deferred
      end

feature {MIXUP_IMPLIES}
   visit_implies (a_implies: MIXUP_IMPLIES)
      require
         a_implies /= Void
      deferred
      end

feature {MIXUP_INTEGER_DIVIDE}
   visit_integer_divide (a_integer_divide: MIXUP_INTEGER_DIVIDE)
      require
         a_integer_divide /= Void
      deferred
      end

feature {MIXUP_INTEGER_MODULO}
   visit_integer_modulo (a_integer_modulo: MIXUP_INTEGER_MODULO)
      require
         a_integer_modulo /= Void
      deferred
      end

feature {MIXUP_LE}
   visit_le (a_le: MIXUP_LE)
      require
         a_le /= Void
      deferred
      end

feature {MIXUP_LT}
   visit_lt (a_lt: MIXUP_LT)
      require
         a_lt /= Void
      deferred
      end

feature {MIXUP_MULTIPLY}
   visit_multiply (a_multiply: MIXUP_MULTIPLY)
      require
         a_multiply /= Void
      deferred
      end

feature {MIXUP_NE}
   visit_ne (a_ne: MIXUP_NE)
      require
         a_ne /= Void
      deferred
      end

feature {MIXUP_OR}
   visit_or (a_or: MIXUP_OR)
      require
         a_or /= Void
      deferred
      end

feature {MIXUP_POWER}
   visit_power (a_power: MIXUP_POWER)
      require
         a_power /= Void
      deferred
      end

feature {MIXUP_SUBTRACT}
   visit_subtract (a_subtract: MIXUP_SUBTRACT)
      require
         a_subtract /= Void
      deferred
      end

feature {MIXUP_XOR}
   visit_xor (a_xor: MIXUP_XOR)
      require
         a_xor /= Void
      deferred
      end

end -- class MIXUP_EXPRESSION_VISITOR
