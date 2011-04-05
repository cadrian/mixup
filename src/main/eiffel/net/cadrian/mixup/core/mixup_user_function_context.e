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
class MIXUP_USER_FUNCTION_CONTEXT

inherit
   MIXUP_CONTEXT
      rename
         make as make_context
      redefine
         get_local, set_local
      end

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE) is
      do
         if args.fast_has(a_name) then
            error("cannot assign a parameter")
         else
            debug
               log.trace.put_line("Setting local: '" + a_name.out + "' => " + a_value.out)
            end
            locals.put(a_value, a_name)
         end
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE is
      do
         Result := args.reference_at(a_name)
         if Result = Void then
            Result := locals.reference_at(a_name)
         end
      end

feature {}
   accept_start (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.start_user_function(Current)
      end

   accept_end (visitor: MIXUP_CONTEXT_VISITOR) is
      do
         visitor.end_user_function(Current)
      end

feature {ANY}
   add_statement (a_statement: MIXUP_STATEMENT) is
      require
         a_statement /= Void
      do
         statements.add_first(a_statement)
      end

   add_statements (a_statements: TRAVERSABLE[MIXUP_STATEMENT]) is
      require
         a_statements /= Void
      local
         i: INTEGER
      do
         from
            i := a_statements.upper
         until
            i < a_statements.lower
         loop
            add_statement(a_statements.item(i))
            i := i - 1
         end
      end

   execute is
      local
         statement: MIXUP_STATEMENT
      do
         from
            yielded := False
         until
            yielded or else statements.is_empty
         loop
            statement := statements.first
            statements.remove_first
            statement.call(Current)
         end
      ensure
         yielded or else statements.is_empty
      end

   yielded: BOOLEAN

   yield (a_value: like value) is
      require
         not yielded
      do
         value := a_value
         yielded := True
      ensure
         value = a_value
         yielded
      end

   set_result (a_value: like value) is
      require
         not yielded
      do
         value := a_value
      ensure
         value = a_value
      end

   value: MIXUP_VALUE
   player: MIXUP_PLAYER
   args: MAP[MIXUP_VALUE, FIXED_STRING]

feature {}
   statements: LINKED_LIST[MIXUP_STATEMENT]
   locals: DICTIONARY[MIXUP_VALUE, FIXED_STRING]

   make (a_parent: MIXUP_CONTEXT; a_player: like player; a_args: like args) is
      require
         a_parent /= Void
         a_player /= Void
         a_args /= Void
      do
         make_context(once "<function>", a_parent)
         player := a_player
         args := a_args
         create statements.make
         create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} locals.make
      ensure
         player = a_player
         args = a_args
      end

invariant
   player /= Void
   args /= Void
   statements /= Void
   locals /= Void

end -- class MIXUP_USER_FUNCTION_CONTEXT
