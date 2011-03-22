-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- Liberty Eiffel is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Liberty Eiffel.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_IDENTIFIER_PART

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING
   args: TRAVERSABLE[MIXUP_VALUE]

   set_args (a_args: like args) is
      do
         args := a_args
      ensure
         args = a_args
      end

feature {MIXUP_IDENTIFIER}
   eval_args (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): TRAVERSABLE[MIXUP_VALUE] is
      local
         actual_args: FAST_ARRAY[MIXUP_VALUE]
         i: INTEGER
      do
         if args = Void then
            create actual_args.make(0)
         else
            create actual_args.with_capacity(args.count)
            from
               i := args.lower
            until
               i > args.upper
            loop
               actual_args.add_last(args.item(i).eval(a_context, a_player))
               i := i + 1
            end
         end
         Result := actual_args
      end

   append_args_in (buffer: STRING) is
      require
         buffer /= Void
         args /= Void
      local
         i: INTEGER
      do
         buffer.extend('(')
         from
            i := args.lower
         until
            i > args.upper
         loop
            if i > args.lower then
               buffer.append(once ", ")
            end
            args.item(i).as_name_in(buffer)
            i := i + 1
         end
         buffer.extend(')')
      end

feature {MIXUP_IDENTIFIER_PART, MIXUP_IDENTIFIER}
   as_name_in (a_name: STRING) is
      require
         a_name /= Void
      do
         a_name.append(name)
         if args /= Void then
            append_args_in(a_name)
         end
      end

feature {}
   make (a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      do
         name := a_name.intern
      ensure
         name = a_name.intern
      end

invariant
   name /= Void

end -- class MIXUP_IDENTIFIER_PART
