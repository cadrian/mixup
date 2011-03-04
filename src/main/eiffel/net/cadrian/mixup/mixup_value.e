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

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      require
         a_name /= Void
      deferred
      end

end
