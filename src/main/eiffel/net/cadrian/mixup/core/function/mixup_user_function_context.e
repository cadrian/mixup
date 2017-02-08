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
   set_local (a_name: FIXED_STRING; a_value: MIXUP_VALUE)
      do
         if args.fast_has(a_name) then
            error("cannot assign a parameter")
         else
            debug
               log.trace.put_line(once "Setting local: '" | a_name | once "' => " | &a_value)
            end
            locals.put(a_value, a_name)
         end
      end

   get_local (a_name: FIXED_STRING): MIXUP_VALUE
      do
         Result := args.reference_at(a_name)
         if Result = Void then
            Result := locals.reference_at(a_name)
         end
      end

   commit (a_commit_context: MIXUP_COMMIT_CONTEXT): like Current
      local
         timing_: MIXUP_MUSIC_TIMING
      do
         a_commit_context.set_context(Current)
         create Result.duplicate(source, name, parent, commit_values(a_commit_context), commit_imports(a_commit_context), args)
         Result.set_timing(timing_.set(0, a_commit_context.bar_number, 0))
      end

   accept (visitor: VISITOR)
      local
         v: MIXUP_CONTEXT_VISITOR
      do
         v ::= visitor
         v.visit_user_function_context(Current)
      end

feature {ANY}
   add_statement (a_statement: MIXUP_STATEMENT)
      require
         a_statement /= Void
      do
         statements.add_first(a_statement)
         debug
            log.trace.put_line(once "statements queue size = " | &statements.count)
         end
      end

   add_statements (a_statements: TRAVERSABLE[MIXUP_STATEMENT])
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

   execute (a_commit_context: MIXUP_COMMIT_CONTEXT)
      local
         statement: MIXUP_STATEMENT
      do
         from
            a_commit_context.set_context(Current)
            yield_source := Void
         until
            yielded or else statements.is_empty
         loop
            statement := statements.first
            statements.remove_first
            log.trace.put_line(once "Calling statement: " | &statement)
            statement.call(a_commit_context)
         end
      ensure
         yielded or else statements.is_empty
      end

   yield (a_source: MIXUP_SOURCE; a_value: like value)
      require
         not yielded
         a_source /= Void
      do
         value := a_value
         yield_source := a_source
      ensure
         value = a_value
         yield_source = a_source
         yielded
      end

   yielded: BOOLEAN
      do
         Result := yield_source /= Void
      end

   yield_source: MIXUP_SOURCE

   set_result (a_value: like value)
      require
         not yielded
      do
         value := a_value
      ensure
         value = a_value
      end

   value: MIXUP_VALUE
   args: MAP[MIXUP_VALUE, FIXED_STRING]

feature {MIXUP_CONTEXT}
   add_child (a_child: MIXUP_CONTEXT)
      do
         check
            {MIXUP_USER_FUNCTION_CONTEXT} ?:= a_child
         end
         -- nothing to do
      end

feature {}
   lookup_in_children (identifier: FIXED_STRING): MIXUP_VALUE
      do
      end

   setup_in_children (identifier: FIXED_STRING; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN): BOOLEAN
      do
      end

feature {}
   statements: RING_ARRAY[MIXUP_STATEMENT]
   locals: DICTIONARY[MIXUP_VALUE, FIXED_STRING]

   make (a_source: like source; a_parent: like parent; a_args: like args)
      require
         a_source /= Void
         a_args /= Void
      do
         args := a_args
         create statements.make(1, 0)
         create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} locals.make
         make_context(a_source, once "<function>", a_parent)
      ensure
         source = a_source
         args = a_args
      end

   duplicate (a_source: like source; a_name: like name; a_parent: like parent; a_values: like values; a_imports: like imports; a_args: like args)
      do
         source := a_source
         parent := a_parent
         name := a_name
         values := a_values
         imports := a_imports
         args := a_args
         create statements.make(1, 0)
         create {HASHED_DICTIONARY[MIXUP_VALUE, FIXED_STRING]} locals.make
         create resolver.make(Current)
      end

invariant
   args /= Void
   statements /= Void
   locals /= Void
   parent /= Void

end -- class MIXUP_USER_FUNCTION_CONTEXT
