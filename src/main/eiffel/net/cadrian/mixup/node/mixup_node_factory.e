deferred class MIXUP_NODE_FACTORY

feature {MIXUP_GRAMMAR}
   list (name: FIXED_STRING): MIXUP_LIST_NODE is
      deferred
      ensure
         Result.name = name
      end

   non_terminal (name: FIXED_STRING; names: TRAVERSABLE[FIXED_STRING]): MIXUP_NON_TERMINAL_NODE is
      require
         not name.is_empty
         names /= Void
      deferred
      ensure
         Result.name = name
      end

   terminal (name: FIXED_STRING; image: MIXUP_IMAGE): MIXUP_TERMINAL_NODE is
      require
         not name.is_empty
         image /= Void
      deferred
      ensure
         Result.name = name
         Result.image.is_equal(image)
      end

end -- class MIXUP_NODE_FACTORY
