class MIXUP_DEFAULT_NODE_FACTORY

inherit
   MIXUP_NODE_FACTORY

create {ANY}
   make

feature {MIXUP_GRAMMAR}
   list (name: FIXED_STRING): MIXUP_LIST_NODE is
      do
         create {MIXUP_LIST_NODE_IMPL}Result.make(name)
      end

   non_terminal (name: FIXED_STRING; names: TRAVERSABLE[FIXED_STRING]): MIXUP_NON_TERMINAL_NODE is
      do
         create {MIXUP_NON_TERMINAL_NODE_IMPL}Result.make(name, names)
      end

   terminal (name: FIXED_STRING; image: MIXUP_IMAGE): MIXUP_TERMINAL_NODE is
      do
         create {MIXUP_TERMINAL_NODE_IMPL}Result.make(name, image)
      end

feature {}
   make is
      do
      end

end -- class MIXUP_DEFAULT_NODE_FACTORY
