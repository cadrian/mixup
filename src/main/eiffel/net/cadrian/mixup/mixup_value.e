deferred class MIXUP_VALUE

inherit
   VISITABLE

feature {ANY}
   is_public: BOOLEAN
   is_constant: BOOLEAN

   set_public (enable: BOOLEAN) is
      do
         is_public := enable
      end

   set_constant (enable: BOOLEAN) is
      do
         is_constant := enable
      end

   eval (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER): MIXUP_VALUE is
      do
         Result := Current
      end

   is_context: BOOLEAN is False
   as_context: MIXUP_CONTEXT is
      require
         is_context
      do
         crash
      end

   is_callable: BOOLEAN is False
   call (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      require
         is_callable
         a_context /= Void
         a_args /= Void
      do
         crash
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      require
         a_name /= Void
      deferred
      end

end
