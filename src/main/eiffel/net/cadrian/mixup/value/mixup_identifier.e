class MIXUP_IDENTIFIER

inherit
   MIXUP_VALUE

create {ANY}
   make

feature {ANY}
   with_prefix (name: ABSTRACT_STRING) is
      require
         name /= Void
      do
         parts.add_first(create {MIXUP_IDENTIFIER_PART}.make(name))
      end

   set_args (args: COLLECTION[MIXUP_VALUE]) is
      require
         args /= Void
      do
         parts.first.set_args(args)
      end

feature {}
   make is
      do
         create {RING_ARRAY[MIXUP_IDENTIFIER_PART]} parts.with_capacity(0, 0)
      end

   parts: COLLECTION[MIXUP_IDENTIFIER_PART]

invariant
   parts /= Void

end
