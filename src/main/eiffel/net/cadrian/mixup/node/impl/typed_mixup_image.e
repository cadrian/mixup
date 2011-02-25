class TYPED_MIXUP_IMAGE[E_]

inherit
   MIXUP_IMAGE

creation {MIXUP_GRAMMAR}
   make

feature {ANY}
   decoded: E_

feature {}
   make (a_image: like image; a_decoded: like decoded; a_blanks: like blanks; a_position: like position) is
      require
         a_image /= Void
         a_decoded /= Void
      do
         image := a_image
         decoded := a_decoded
         blanks := a_blanks
         position := a_position
      ensure
         image = a_image
         decoded = a_decoded
         blanks = a_blanks
         position = a_position
      end

invariant
   decoded /= Void

end -- class TYPED_MIXUP_IMAGE
