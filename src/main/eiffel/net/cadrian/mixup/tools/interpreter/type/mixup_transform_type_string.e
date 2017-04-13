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
class MIXUP_TRANSFORM_TYPE_STRING

inherit
   MIXUP_TRANSFORM_TYPE_IMPL[STRING]

insert
   ARGUMENTS
      undefine
         is_equal
      end

create {MIXUP_TRANSFORM_TYPES}
   make

feature {ANY}
   is_comparable: BOOLEAN True

feature {MIXUP_TRANSFORM_INTERPRETER, MIXUP_TRANSFORM_TYPE, MIXUP_TRANSFORM_VALUE}
   eq (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      local
         l, r: MIXUP_TRANSFORM_VALUE_STRING
      do
         l ::= left
         r ::= right
         Result := l.value.is_equal(r.value)
      end

   gt (left, right: MIXUP_TRANSFORM_VALUE): BOOLEAN
      local
         l, r: MIXUP_TRANSFORM_VALUE_STRING
      do
         l ::= left
         r ::= right
         Result := l.value > r.value
      end

   add (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         l, r, res: MIXUP_TRANSFORM_VALUE_STRING
      do
         if right.type = Current then
            l ::= left
            r ::= right
            create res.make
            res.set_value(l.value + r.value)
         else
            set_error("cannot add string and #(1)" # right.type.name)
         end
      end

   subtract (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot subtract strings")
         else
            set_error("cannot subtract string and #(1)" # right.type.name)
         end
      end

   multiply (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      local
         l, res: MIXUP_TRANSFORM_VALUE_STRING; r: MIXUP_TRANSFORM_VALUE_NUMERIC; i: INTEGER; s: STRING
      do
         if right.type = type_numeric then
            if r.value < 0 then
               set_error("cannot multiply a string bya negative number")
            else
               l ::= left
               r ::= right
               s := ""
               from
                  i := 1
               until
                  i > r.value
               loop
                  s.append(l.value)
                  i := i + 1
               end
               create res.make
               res.set_value(s)
            end
         elseif right.type = Current then
            set_error("cannot multiply strings")
         else
            set_error("cannot multiply string and #(1)" # right.type.name)
         end
      end

   divide (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot divide strigns")
         else
            set_error("cannot divide string and #(1)" # right.type.name)
         end
      end

   power (left, right: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         if right.type = Current then
            set_error("cannot take power of strings")
         else
            set_error("cannot take power of string by #(1)" # right.type.name)
         end
      end

feature {ANY}
   has_field (field_name: STRING): BOOLEAN
      do
         check not Result end
      end

   field (field_name: STRING; target: MIXUP_TRANSFORM_VALUE): MIXUP_TRANSFORM_VALUE
      do
         set_error("internal error: unexpected call")
      end

   value_of (image: MIXUP_TRANSFORM_NODE_IMAGE): MIXUP_TRANSFORM_VALUE
      local
         str: MIXUP_TRANSFORM_NODE_IMAGE_TYPED[STRING]
         arg: MIXUP_TRANSFORM_NODE_IMAGE_TYPED[INTEGER]
         res: MIXUP_TRANSFORM_VALUE_STRING
      do
         create res.make
         if Current = type_string then
            check str ?:= image end
            str ::= image
            res.set_value(str.value)
            Result := res
         elseif Current = type_argument then
            check arg ?:= image end
            arg ::= image
            if argument_count > arg.value then
               res.set_value(argument(arg.value + 1))
               Result := res
            else
               set_error("argument #(1) not found" # image.image)
            end
         else
            set_error("internal error: invalid type")
         end
      end

   new_value: MIXUP_TRANSFORM_VALUE
      do
         create {MIXUP_TRANSFORM_VALUE_STRING} Result.make
      end

feature {MIXUP_TRANSFORM_TYPES}
   init
      local
         calls: MIXUP_TRANSFORM_CALLS
      do
         calls.register_function("utf_to_iso",
                                 Void, {FAST_ARRAY[MIXUP_TRANSFORM_TYPE] << type_string >>}, type_string,
                                 agent utf_to_iso(?))
      end

feature {}
   utf_to_iso (context: MIXUP_TRANSFORM_CALL_CONTEXT): TUPLE[MIXUP_TRANSFORM_VALUE, ABSTRACT_STRING]
         -- utf_to_iso(text)
      require
         context.argument_count = 1
         context.argument_is_string(1)
      local
         utf, iso: STRING
         conv: MIXUP_STRING_CONVERSION
         str: MIXUP_TRANSFORM_VALUE_STRING
         err: ABSTRACT_STRING
      do
         utf := context.argument_string(1)
         iso := conv.utf8_to_iso(utf, conv.Format_iso_8859_15)
         if iso = Void then
            io.put_line("#(1) => **ERROR**" # utf)
            err := "invalid UTF-8 string or impossible to convert to ISO-8815-15"
         else
            io.put_line("#(1) => #(2)" # utf # iso)
            create str.make
            str.set_value(iso)
         end
         Result := [str, err]
      end

end -- class MIXUP_TRANSFORM_TYPE_STRING
