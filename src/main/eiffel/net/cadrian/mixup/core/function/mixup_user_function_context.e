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
      end

create {ANY}
   make

create {MIXUP_USER_FUNCTION_CONTEXT}
   duplicate

feature {ANY}
   bar_number: INTEGER is
      do
         Result := timing.first_bar_number
      end

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

   commit (a_player: MIXUP_PLAYER; a_start_bar_number: INTEGER): like Current is
      local
         timing_: MIXUP_MUSIC_TIMING
      do
         check
            a_player = player
         end
         create Result.duplicate(source, name, parent, player, commit_values(a_player, a_start_bar_number), commit_imports(a_player, a_start_bar_number), args)
         Result.set_timing(timing_.set(0, a_start_bar_number, 0))
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_user_function_context(Current)
      end

feature {ANY}
   add_statement (a_statement: MIXUP_STATEMENT) is
      require
         a_statement /= Void
      do
         statements.add_first(a_statement)
         debug
            log.trace.put_line("statements queue size = " + statements.count.out)
         end
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
            log.trace.put_line("Calling statement: " + statement.out)
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

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT) is
      do
         check
            {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_child
         end
         -- nothing to do
      end

feature {}
   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE is
      do
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN is
      do
      end

feature {}
   statements: RING_ARRAY[MIXUP_STATEMENT]
   locals: DICTIONARY[MIXUP_VALUE, FIXED_STRING]

   make (a_source: like source; a_parent: MIXUP_CONTEXT; a_player: like player; a_args: like args) is
      require
         a_source /= Void
         a_parent /= Void
         a_player /= Void
         a_args /= Void
      do
         player := a_player
         args := a_args
         create statements.make(1, 0)
         create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} locals.make
         make_context(a_source, once "<function>", a_parent)
      ensure
         source = a_source
         player = a_player
         args = a_args
      end

   duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_player: like player; a_values: like values; a_imports: like imports; a_args: like args) is
      do
         source := a_source
         name := a_name
         parent := a_parent
         values := a_values
         imports := a_imports
         player := a_player
         args := a_args
         create statements.make(1, 0)
         create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} locals.make
         create resolver.make(Current)
      end

invariant
   player /= Void
   args /= Void
   statements /= Void
   locals /= Void

end -- class MIXUP_USER_FUNCTION_CONTEXT
