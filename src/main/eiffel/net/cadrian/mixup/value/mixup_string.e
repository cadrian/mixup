class MIXUP_STRING

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: FIXED_STRING

feature {}
   make (a_value: ABSTRACT_STRING) is
      require
         a_value /= Void
      do
         value := a_value.intern
      ensure
         value = a_value.intern
      end

invariant
   value /= Void

end
