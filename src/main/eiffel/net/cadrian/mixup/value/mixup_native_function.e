class MIXUP_NATIVE_FUNCTION

inherit
   MIXUP_FUNCTION

create {ANY}
   make

feature {ANY}
   name: FIXED_STRING

   accept (visitor: VISITOR) is
      local
         v: MIXUP_VALUE_VISITOR
      do
         v ::= visitor
         v.visit_native_function(Current)
      end

   call (a_context: MIXUP_CONTEXT; a_args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         Result := native_caller.item([a_context, a_args])
      end

feature {}
   make (a_name: ABSTRACT_STRING; a_native_caller: like native_caller) is
      require
         a_name /= Void
         a_native_caller /= Void
      do
         name := a_name.intern
         native_caller := a_native_caller
      ensure
         name = a_name.intern
         native_caller = a_native_caller
      end

   native_caller: FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE]

invariant
   name /= Void
   native_caller /= Void

end
