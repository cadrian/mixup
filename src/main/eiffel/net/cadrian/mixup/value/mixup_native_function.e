class MIXUP_NATIVE_FUNCTION

inherit
   MIXUP_FUNCTION

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_native_function(Current)
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

end
