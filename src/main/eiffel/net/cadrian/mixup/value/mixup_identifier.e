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

inherit
   MIXUP_VALUE
      redefine
         eval, out_in_tagged_out_memory
      end

create {ANY}
   make

feature {ANY}
   is_callable: BOOLEAN is False

   add_identifier_part (a_source: like source; name: ABSTRACT_STRING) is
      require
         name /= Void
      do
         parts.add_last(create {MIXUP_IDENTIFIER_PART}.make(a_source, name))
         debug
            debug_name.clear_count
            as_name_in(debug_name)
         end
      end

   set_args (args: COLLECTION[MIXUP_EXPRESSION]) is
      require
         args /= Void
      do
         parts.last.set_args(args)
         debug
            debug_name.clear_count
            as_name_in(debug_name)
         end
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_identifier(Current)
      end

   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; do_call: BOOLEAN): MIXUP_VALUE is
      local
         value: MIXUP_VALUE
      do
         value := lookup(a_context, a_player).first
         if value /= Void and then value.is_callable then
            if do_call then
               Result := value.call(parts.last.source, a_player, parts.last.eval_args(a_context, a_player))
            else
               create {MIXUP_AGENT_FUNCTION} Result.make(parts.last.source, value, parts.last.eval_args(a_context, a_player))
            end
         else
            Result := value
         end
         if Result = Void then
            info("nothing returned")
            value := no_value
         end
      end

   assign (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_value: MIXUP_VALUE; is_const: BOOLEAN; is_public: BOOLEAN; is_local: BOOLEAN) is
      local
         context: like lookup
      do
         context := lookup(a_context, a_player)
         parts.last.append_eval_args_in(context.third, a_context, a_player)
         context.second.setup(context.third.intern, a_value, is_const, is_public, is_local)
      end

   as_name: STRING is
      do
         Result := ""
         as_name_in(Result)
      ensure
         Result /= Void
      end

   is_simple: BOOLEAN is
      do
         Result := parts.count = 1 and then parts.first.args = Void
      end

   simple_name: FIXED_STRING is
      require
         is_simple
      do
         Result := parts.first.name
      end

   out_in_tagged_out_memory is
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
   as_name_in (a_name: STRING) is
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
   make (a_source: like source) is
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

   lookup (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): TUPLE[MIXUP_VALUE, MIXUP_CONTEXT, STRING] is
      local
         context: MIXUP_CONTEXT
         i: INTEGER; name_buffer: STRING
         value: MIXUP_VALUE
      do
         context := a_context
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
            value := a_context.lookup(name_buffer.intern, a_player, True)
            if value /= Void then
               if value.is_context then
                  context := value.as_context
                  name_buffer.clear_count
               elseif i < parts.upper then
                  fatal("not a context")
               end
            elseif parts.item(i).args /= Void then
               parts.item(i).append_eval_args_in(name_buffer, a_context, a_player)
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
