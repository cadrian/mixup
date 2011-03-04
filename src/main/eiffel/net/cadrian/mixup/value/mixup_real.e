class MIXUP_REAL

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: REAL

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_real(Current)
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         value.append_in(a_name)
      end

feature {}
   make (a_value: like value) is
      do
         value := a_value
      ensure
         value = a_value
      end

end
