class MIXUP_IDENTIFIER

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   add_identifier_part (name: ABSTRACT_STRING) is
      require
         name /= Void
      do
         parts.add_last(create {MIXUP_IDENTIFIER_PART}.make(name))
      end

   set_args (args: COLLECTION[MIXUP_VALUE]) is
      require
         args /= Void
      do
         parts.last.set_args(args)
      end

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_identifier(Current)
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
      end

   parts: COLLECTION[MIXUP_IDENTIFIER_PART]

invariant
   parts /= Void

end
