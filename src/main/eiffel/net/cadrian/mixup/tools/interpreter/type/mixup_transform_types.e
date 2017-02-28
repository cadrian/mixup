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
expanded class MIXUP_TRANSFORM_TYPES
   --
   -- Known inference types
   --

feature {ANY}
   type_numeric: MIXUP_TRANSFORM_TYPE_NUMERIC then type_numeric_
      ensure
         valid_type(Result)
      end

   type_string: MIXUP_TRANSFORM_TYPE_STRING then type_string_
      ensure
         valid_type(Result)
      end

   type_argument: MIXUP_TRANSFORM_TYPE_STRING then type_argument_
      ensure
         valid_type(Result)
      end

   type_boolean: MIXUP_TRANSFORM_TYPE_BOOLEAN then type_boolean_
      ensure
         valid_type(Result)
      end

   type_event: MIXUP_TRANSFORM_TYPE_EVENT then type_event_
      ensure
         valid_type(Result)
      end

   type_associative (index, value: MIXUP_TRANSFORM_TYPE): MIXUP_TRANSFORM_TYPE_ASSOCIATIVE
      require
         index.is_comparable
         value /= Void
      then
         type_associative_(index, value)
      ensure
         valid_type(Result)
      end

   valid_type (a_type: MIXUP_TRANSFORM_TYPE): BOOLEAN
      require
         a_type /= Void
      do
         Result := types.has(a_type)
      end

feature {}
   type_numeric_: MIXUP_TRANSFORM_TYPE_NUMERIC
      once
         create Result.make("numeric")
      end

   type_string_: MIXUP_TRANSFORM_TYPE_STRING
      once
         create Result.make("string")
      end

   type_argument_: MIXUP_TRANSFORM_TYPE_STRING
      once
         create Result.make("argument")
      end

   type_boolean_: MIXUP_TRANSFORM_TYPE_BOOLEAN
      once
         create Result.make("boolean")
      end

   type_event_: MIXUP_TRANSFORM_TYPE_EVENT
      once
         create Result.make("event")
      end

   type_associative_ (index, value: MIXUP_TRANSFORM_TYPE): MIXUP_TRANSFORM_TYPE_ASSOCIATIVE
      require
         index.is_comparable
         value /= Void
      local
         type: MIXUP_TRANSFORM_TYPE; i: INTEGER
      do
         -- there aren't that many (sensible) combinations. For now
         -- I'll just scan the set.
         from
            i := types.lower
         until
            Result /= Void or else i > types.upper
         loop
            type := types.item(i)
            if Result ?:= type then
               Result ::= type
               if not Result.index_type.is_equal(index) or else not Result.value_type.is_equal(value) then
                  Result := Void
               end
            end
            i := i + 1
         end
         if Result = Void then
            create Result.make("associative[" + index.name + "->" + value.name + "]", index, value)
            types.add(Result)
            Result.init
         end
      ensure
         valid_type(Result)
      end

   types: SET[MIXUP_TRANSFORM_TYPE]
      once
         Result := {HASHED_SET[MIXUP_TRANSFORM_TYPE] << type_numeric_, type_string_, type_argument_, type_boolean_, type_event_ >> }
         Result.do_all(agent {MIXUP_TRANSFORM_TYPE}.init)
      end

end -- class MIXUP_TRANSFORM_TYPES
