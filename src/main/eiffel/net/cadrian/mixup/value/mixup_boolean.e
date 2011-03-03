class MIXUP_BOOLEAN

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: BOOLEAN

feature {}
   make (a_value: like value) is
      do
         value := a_value
      ensure
         value = a_value
      end

end
