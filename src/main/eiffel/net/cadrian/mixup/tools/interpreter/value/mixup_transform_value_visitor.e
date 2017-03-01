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
deferred class MIXUP_TRANSFORM_VALUE_VISITOR

feature {MIXUP_TRANSFORM_VALUE_ASSOCIATIVE}
   visit_value_associative (a_value: MIXUP_TRANSFORM_VALUE_ASSOCIATIVE)
      require
         a_value /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_VALUE_BOOLEAN}
   visit_value_boolean (a_value: MIXUP_TRANSFORM_VALUE_BOOLEAN)
      require
         a_value /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_VALUE_EVENT}
   visit_value_event (a_value: MIXUP_TRANSFORM_VALUE_EVENT)
      require
         a_value /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_VALUE_NUMERIC}
   visit_value_numeric (a_value: MIXUP_TRANSFORM_VALUE_NUMERIC)
      require
         a_value /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_VALUE_STRING}
   visit_value_string (a_value: MIXUP_TRANSFORM_VALUE_STRING)
      require
         a_value /= Void
      deferred
      end

feature {MIXUP_TRANSFORM_VALUE_UNKNOWN}
   visit_value_unknown (a_value: MIXUP_TRANSFORM_VALUE_UNKNOWN)
      require
         a_value /= Void
      deferred
      end

end -- class MIXUP_TRANSFORM_VALUE_VISITOR
