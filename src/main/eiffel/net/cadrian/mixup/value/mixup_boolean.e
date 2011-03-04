class MIXUP_BOOLEAN

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: BOOLEAN

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_boolean(Current)
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         if value then
            a_name.append(once "True")
         else
            a_name.append(once "False")
         end
      end

feature {}
   make (a_value: like value) is
      do
         value := a_value
      ensure
         value = a_value
      end

end
