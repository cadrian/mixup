class UNTYPED_MIXUP_IMAGE

inherit
   MIXUP_IMAGE

creation {MIXUP_GRAMMAR}
   make

feature {}
   make (a_image: like image; a_blanks: like blanks; a_position: like position) is
      require
         a_image /= Void
      do
         image := a_image
         blanks := a_blanks
         position := a_position
      ensure
         image = a_image
         blanks = a_blanks
         position = a_position
      end

end -- class UNTYPED_MIXUP_IMAGE
