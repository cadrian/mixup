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

feature {MIXUP_IDENTIFIER_PART, MIXUP_IDENTIFIER}
   as_name_in (a_name: STRING) is
      require
         a_name /= Void
      local
         i: INTEGER
      do
         a_name.append(name)
         if args /= Void then
            a_name.extend('(')
            from
               i := args.lower
            until
               i > args.upper
            loop
               if i > args.lower then
                  a_name.append(once ", ")
               end
               args.item(i).as_name_in(a_name)
               i := i + 1
            end
            a_name.extend(')')
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

end
