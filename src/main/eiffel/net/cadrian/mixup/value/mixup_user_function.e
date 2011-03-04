class MIXUP_USER_FUNCTION

inherit
   MIXUP_FUNCTION

feature {ANY}
   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_user_function(Current)
      end

end
