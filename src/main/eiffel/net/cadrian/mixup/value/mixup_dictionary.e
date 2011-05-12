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
class MIXUP_DICTIONARY

inherit
   MIXUP_VALUE
      undefine
         out_in_tagged_out_memory
      redefine
         eval
      end
   MAP[MIXUP_VALUE, MIXUP_VALUE]
      undefine
         is_equal
      end

create {ANY}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_dictionary(Current)
      end

   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      local
         i: INTEGER; k, v: MIXUP_VALUE
      do
         create evaled.with_capacity(agent hashcoder.hash_code, keys.count)
         from
            i := keys.lower
         until
            i > keys.upper
         loop
            k := keys.item(i).eval(a_context, a_player)
            v := values.item(i).eval(a_context, a_player)
            if k = Void then
               fatal("could not compute key")
            elseif v = Void then
               fatal("could not compute value")
            else
               evaled.add(v, k)
            end
            i := i + 1
         end
         Result := Current
      end

   count: INTEGER is
      do
         Result := evaled.count
      end

   has (k: MIXUP_VALUE): BOOLEAN is
      do
         Result := evaled.has(k)
      end

   at (k: MIXUP_VALUE): MIXUP_VALUE is
      do
         Result := evaled.at(k)
      end

   reference_at (k: MIXUP_VALUE): MIXUP_VALUE is
      do
         Result := evaled.reference_at(k)
      end

   fast_has (k: MIXUP_VALUE): BOOLEAN is
      do
         Result := evaled.fast_has(k)
      end

   fast_at (k: MIXUP_VALUE): MIXUP_VALUE is
      do
         Result := evaled.fast_at(k)
      end

   fast_reference_at (k: MIXUP_VALUE): MIXUP_VALUE is
      do
         Result := evaled.fast_reference_at(k)
      end

   item (index: INTEGER): MIXUP_VALUE is
      do
         Result := evaled.item(index)
      end

   key (index: INTEGER): MIXUP_VALUE is
      do
         Result := evaled.key(index)
      end

   new_iterator_on_items: ITERATOR[MIXUP_VALUE] is
      do
         Result := evaled.new_iterator_on_items
      end

   new_iterator_on_keys: ITERATOR[MIXUP_VALUE] is
      do
         Result := evaled.new_iterator_on_keys
      end

   internal_key (k: MIXUP_VALUE): MIXUP_VALUE is
      do
         Result := evaled.internal_key(k)
      end

feature {}
   hashcoder: MIXUP_VALUE_HASHCODER is
      once
         create Result.make
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (buffer: STRING) is
      local
         i: INTEGER
      do
         buffer.extend('{')
         from
            i := keys.lower
         until
            i > keys.upper
         loop
            if i > keys.lower then
               buffer.append(once ", ")
            end
            keys.item(i).as_name_in(buffer)
            buffer.append(once ": ")
            values.item(i).as_name_in(buffer)
            i := i + 1
         end
         buffer.extend('}')
      end

feature {ANY}
   add (a_value, a_key: MIXUP_EXPRESSION) is
      require
         a_value /= Void
         a_key /= Void
      do
         keys.add_last(a_key)
         values.add_last(a_value)
      ensure
         keys.count = old keys.count + 1
         keys.last = a_key
         values.count = old values.count + 1
         values.last = a_value
      end

feature {}
   make (a_source: like source) is
      require
         a_source /= Void
      do
         source := a_source
         create keys.make(0)
         create values.make(0)
      ensure
         source = a_source
      end

   keys: FAST_ARRAY[MIXUP_EXPRESSION]
   values: FAST_ARRAY[MIXUP_EXPRESSION]

   evaled: EXT_HASHED_DICTIONARY[MIXUP_VALUE, MIXUP_VALUE]

invariant
   keys.count = values.count
   keys.lower = values.lower

   evaled /= Void implies evaled.count = keys.count

end -- class MIXUP_DICTIONARY
