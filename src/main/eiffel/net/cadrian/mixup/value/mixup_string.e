class MIXUP_STRING

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: FIXED_STRING

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_string(Current)
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(image)
      end

feature {}
   image: FIXED_STRING

   make (a_value, a_image: ABSTRACT_STRING) is
      require
         a_value /= Void
         a_image /= Void
      do
         value := a_value.intern
         image := a_image.intern
      ensure
         value = a_value.intern
         image = a_image.intern
      end

invariant
   value /= Void

end
