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
