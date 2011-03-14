class MIXUP_MUSIC_VALUE

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   value: MIXUP_MUSIC

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_music(Current)
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(once "<music>")
      end

feature {}
   make (a_value: like value) is
      do
         value := a_value
      ensure
         value = a_value
      end

end
