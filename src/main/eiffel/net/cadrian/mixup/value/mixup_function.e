deferred class MIXUP_FUNCTION

inherit
   MIXUP_VALUE

feature {MIXUP_IDENTIFIER_PART}
   frozen as_name_in (a_name: STRING) is
      do
         a_name.append(once "<function>")
      end

end
