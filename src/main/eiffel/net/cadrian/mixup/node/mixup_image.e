deferred class MIXUP_IMAGE

inherit
   PARSER_IMAGE
      redefine
         out_in_tagged_out_memory, is_equal
      end

feature {ANY}
   is_equal (other: like Current): BOOLEAN is
         -- Redefined because SmartEiffel's default is_equal generates bad code in some strange situations
      do
         Result := position = other.position
            and then image.is_equal(other.image)
      end

feature {ANY}
   image: STRING
         -- the real image of the token

   blanks: STRING
         -- the leading blanks and comments (before the `image' itself)

   line: INTEGER is
      do
         Result := position.line
      end

   column: INTEGER is
      do
         Result := position.column
      end

   index: INTEGER is
      do
         Result := position.index
      end

   out_in_tagged_out_memory is
      do
         tagged_out_memory.append(image)
      end

feature {MIXUP_IMAGE}
   position: MIXUP_POSITION
         -- the position of the `image' (discarding the leading `blanks')

invariant
   image /= Void

end -- class MIXUP_IMAGE
