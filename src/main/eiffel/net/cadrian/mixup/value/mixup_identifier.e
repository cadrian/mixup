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
class MIXUP_IDENTIFIER
   --
   -- Using a symbol. Note: symbol definition is simply a STRING (see MIXUP_CONTEXT values)
   --

inherit
   MIXUP_VALUE
      redefine
         out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   add_identifier_part (a_source: like source; name: ABSTRACT_STRING)
      require
         name /= Void
      do
         parts.add_last(create {MIXUP_IDENTIFIER_PART}.make(a_source, name))
         debug
            debug_name.clear_count
            as_name_in(debug_name)
         end
      end

   set_args (args: COLLECTION[MIXUP_EXPRESSION])
      require
         args /= Void
      do
         parts.last.set_args(args)
         debug
            debug_name.clear_count
            as_name_in(debug_name)
         end
      end

   accept (visitor: VISITOR)
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_identifier(Current)
      end

   assign (a_commit_context: MIXUP_COMMIT_CONTEXT; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN)
      local
         context: like lookup
      do
         context := lookup(a_commit_context)
         if parts.last.args /= Void then
            parts.last.append_eval_args_in(context.third, a_commit_context)
         end
         context.second.setup(context.third.intern, a_value, is_const, is_public, is_local)
      end

   as_name: STRING
      do
         Result := ""
         as_name_in(Result)
      ensure
         Result /= Void
      end

   is_simple: BOOLEAN
      do
         Result := parts.count = 1 and then parts.first.args = Void
      end

   simple_name: FIXED_STRING
      require
         is_simple
      do
         Result := parts.first.name
      end

   out_in_tagged_out_memory
      local
         i: INTEGER
      do
         from
            i := parts.lower
         until
            i > parts.upper
         loop
            if i > parts.lower then
               tagged_out_memory.extend('.')
            end
            parts.item(i).out_in_tagged_out_memory
            i := i + 1
         end
      end

feature {MIXUP_EXPRESSION, MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING)
      local
         i: INTEGER
      do
         from
            i := parts.lower
         until
            i > parts.upper
         loop
            if i > parts.lower then
               a_name.extend('.')
            end
            parts.item(i).as_name_in(a_name)
            i := i + 1
         end
      end

feature {}
   make (a_source: like source)
      require
         a_source /= Void
      do
         source := a_source
         create {RING_ARRAY[MIXUP_IDENTIFIER_PART]} parts.with_capacity(0, 0)
         debug
            debug_name := ""
         end
         create no_value.make(a_source)
      ensure
         source = a_source
      end

   debug_name: STRING
   no_value: MIXUP_NO_VALUE

   eval_ (a_commit_context: MIXUP_COMMIT_CONTEXT; do_call: BOOLEAN): MIXUP_VALUE
      local
         value: MIXUP_VALUE
      do
         value := lookup(a_commit_context).first
         if value /= Void then
            value := value.eval(a_commit_context, do_call)
         end
         if value /= Void and then value.is_callable then
            if do_call then
               Result := value.call(parts.last.source, a_commit_context, parts.last.eval_args(a_commit_context))
            else
               create {MIXUP_AGENT_FUNCTION} Result.make(parts.last.source, value, parts.last.eval_args(a_commit_context))
            end
         else
            Result := value
         end
         if Result = Void then
            info("nothing returned")
            Result := no_value
         end
      end

   lookup (a_commit_context: MIXUP_COMMIT_CONTEXT): TUPLE[MIXUP_VALUE, MIXUP_CONTEXT, STRING]
      local
         context: MIXUP_CONTEXT
         i: INTEGER; name_buffer: STRING
         value: MIXUP_VALUE
      do
         context := a_commit_context.context
         name_buffer := ""
         from
            i := parts.lower
         until
            i > parts.upper
         loop
            if not name_buffer.is_empty then
               name_buffer.extend('.')
            end
            name_buffer.append(parts.item(i).name)
            value := context.lookup(name_buffer.intern, True)
            if value /= Void then
               if value.is_context then
                  context := value.as_context
                  name_buffer.clear_count
               elseif i < parts.upper then
                  fatal("not a context")
               end
            elseif parts.item(i).args /= Void then
               parts.item(i).append_eval_args_in(name_buffer, a_commit_context)
            end
            i := i + 1
         end

         Result := [value, context, name_buffer]
      ensure
         Result /= Void
         Result.second /= Void
         Result.third /= Void
      end

feature {MIXUP_VALUE_VISITOR}
   parts: COLLECTION[MIXUP_IDENTIFIER_PART]

invariant
   parts /= Void

end -- class MIXUP_IDENTIFIER
