class MIXUP_NO_VALUE

inherit
   MIXUP_VALUE
      undefine
         is_equal
      end

insert
   SINGLETON

create {ANY}
   make

feature {ANY}
   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_no_value(Current)
      end

feature {MIXUP_IDENTIFIER_PART}
   as_name_in (a_name: STRING) is
      do
         a_name.append(once "<void>")
      end

feature {}
   make is
      do
      end

end
