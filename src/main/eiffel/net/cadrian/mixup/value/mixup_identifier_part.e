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
class MIXUP_IDENTIFIER_PART

insert
   MIXUP_ERRORS
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING
   args: TRAVERSABLE[MIXUP_EXPRESSION]

   set_args (a_args: like args) is
      do
         args := a_args
      ensure
         args = a_args
      end

   out_in_tagged_out_memory is
      local
         i: INTEGER
      do
         tagged_out_memory.append(name)
         if args /= Void then
            tagged_out_memory.extend('(')
            from
               i := args.lower
            until
               i > args.upper
            loop
               if i > args.lower then
                  tagged_out_memory.append(once ", ")
               end
               args.item(i).out_in_tagged_out_memory
               i := i + 1
            end
            tagged_out_memory.extend(')')
         end
      end

feature {MIXUP_IDENTIFIER}
   eval_args (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): TRAVERSABLE[MIXUP_VALUE] is
      local
         actual_args: FAST_ARRAY[MIXUP_VALUE]
         arg: MIXUP_VALUE
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
               arg := args.item(i).eval(a_context, a_player, True)
               if arg = Void then
                  sedb_breakpoint
                  actual_args.add_last(Void)
               else
                  arg.append_to(actual_args)
               end
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

   append_eval_args_in (buffer: STRING; a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
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
            args.item(i).eval(a_context, a_player, True).as_name_in(buffer)
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
   make (a_source: like source; a_name: ABSTRACT_STRING) is
      require
         a_source /= Void
         a_name /= Void
      do
         source := a_source
         name := a_name.intern
      ensure
         source = a_source
         name = a_name.intern
      end

invariant
   source /= Void
   name /= Void

end -- class MIXUP_IDENTIFIER_PART
