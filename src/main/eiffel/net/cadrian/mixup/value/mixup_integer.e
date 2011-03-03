class MIXUP_INTEGER

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: INTEGER_64

feature {}
   make (a_value: like value) is
      do
         value := a_value
      ensure
         value = a_value
      end

end
