class MIXUP_REAL

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: REAL

feature {}
   make (a_value: like value) is
      do
         value := a_value
      ensure
         value = a_value
      end

end
