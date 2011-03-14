deferred class MIXUP_NATIVE_PROVIDER

feature {ANY}
   item (name: STRING): FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE] is
      require
         name /= Void
      deferred
      ensure
         Result /= Void
      end

end
