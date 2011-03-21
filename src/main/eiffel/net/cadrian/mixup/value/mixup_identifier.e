class MIXUP_IDENTIFIER

inherit
   MIXUP_VALUE
      redefine
         eval
      end

create {ANY}
   make

feature {ANY}
   add_identifier_part (name: ABSTRACT_STRING) is
      require
         name /= Void
      do
         parts.add_last(create {MIXUP_IDENTIFIER_PART}.make(name))
         debug
            debug_name.clear_count
            as_name_in(debug_name)
         end
      end

   set_args (args: COLLECTION[MIXUP_VALUE]) is
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

   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      local
         context: MIXUP_CONTEXT
         i: INTEGER; name_buffer: STRING
         value: MIXUP_VALUE
         args: TRAVERSABLE[MIXUP_VALUE]
      do
         context := a_context
         name_buffer := once ""
         name_buffer.clear_count
         from
            i := parts.lower
         until
            i > parts.upper
         loop
            if not name_buffer.is_empty then
               name_buffer.extend('.')
            end
            name_buffer.append(parts.item(i).name)
            value := a_context.lookup(name_buffer.intern, True)
            if value /= Void then
               if value.is_callable then
                  args := parts.item(i).eval_args(a_context, a_player)
                  Result := value.call(a_context, a_player, args)
               else
                  Result := value
               end
               if Result = Void then
                  if i < parts.upper then
                     not_yet_implemented -- error: nothing returned
                  end
                  Result := no_value
               elseif Result /= Void and then Result.is_context then
                  context := Result.as_context
                  name_buffer.clear_count
               elseif i < parts.upper then
                  not_yet_implemented -- error: not a context
               end
            elseif parts.item(i).args /= Void then
               parts.item(i).append_args_in(name_buffer)
            end
            i := i + 1
         end
      end

   as_name: STRING is
      do
         Result := ""
         as_name_in(Result)
      ensure
         Result /= Void
      end

feature {MIXUP_IDENTIFIER_PART}
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
   make is
      do
         create {RING_ARRAY[MIXUP_IDENTIFIER_PART]} parts.with_capacity(0, 0)
         debug
            debug_name := ""
         end
      end

   debug_name: STRING

   no_value: MIXUP_NO_VALUE is
      once
         create Result.make
      end

feature {MIXUP_VALUE_VISITOR}
   parts: COLLECTION[MIXUP_IDENTIFIER_PART]

invariant
   parts /= Void

end
