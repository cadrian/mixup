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

   call (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         not_yet_implemented
      end

end
