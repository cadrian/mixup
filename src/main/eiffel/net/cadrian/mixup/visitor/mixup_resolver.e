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
class MIXUP_RESOLVER

inherit
   MIXUP_VALUE_VISITOR

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   resolve (a_identifier: MIXUP_IDENTIFIER; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      local
         identifier: MIXUP_IDENTIFIER
      do
         current_player := a_player
         identifier := resolved_identifier(a_identifier)
         if identifier /= Void then
            if identifier.is_simple then
               Result := locals.reference_at(identifier.simple_name)
            end
            if Result = Void then
               Result := identifier.eval(context, a_player)
            end
         end
      end

   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      require
         a_name /= Void
         a_value /= Void
      do
         debug
            log.trace.put_line("Setting local: '" + a_name.out + "' => " + a_value.out)
         end
         locals.put(a_value, a_name)
      end

feature {MIXUP_RESOLVER}
   resolved_identifier (a_identifier: MIXUP_IDENTIFIER): MIXUP_IDENTIFIER is
      local
         i: INTEGER
      do
         create Result.make
         from
            i := a_identifier.parts.lower
         until
            i > a_identifier.parts.upper
         loop
            Result.add_identifier_part(a_identifier.parts.item(i).name)
            if a_identifier.parts.item(i).args /= Void then
               Result.set_args(resolved_args(a_identifier.parts.item(i).args))
            end
            i := i + 1
         end
      end

feature {}
   resolved_args (args: TRAVERSABLE[MIXUP_EXPRESSION]): FAST_ARRAY[MIXUP_VALUE] is
      require
         args /= Void
      local
         i: INTEGER; arg: MIXUP_VALUE
      do
         create Result.with_capacity(args.count)
         from
            i := args.lower
         until
            i > args.upper
         loop
            arg := args.item(i).eval(context, current_player)
            arg.accept(Current)
            Result.add_last(value)
            i := i + 1
         end
      ensure
         Result.count = args.count
      end

feature {MIXUP_YIELD_ITERATOR}
   visit_yield_iterator (a_yield_iterator: MIXUP_YIELD_ITERATOR) is
      do
         value := a_yield_iterator
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
         value := a_boolean
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      do
         value := resolve(a_identifier, current_player)
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
         value := a_integer
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
         value := a_real
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
         value := a_string
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      do
         value := a_function
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
         value := a_function
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
         value := a_music
      end

feature {}
   make (a_context: like context) is
      require
         a_context /= Void
      do
         context := a_context
         create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} locals.make
      ensure
         context = a_context
      end

   context: MIXUP_CONTEXT
   value: MIXUP_VALUE
   current_player: MIXUP_PLAYER
   locals: DICTIONARY[MIXUP_VALUE, FIXED_STRING]

invariant
   context /= Void
   locals /= Void

end -- class MIXUP_RESOLVER
