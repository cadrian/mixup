expanded class MIXUP_NOTES_ITERATOR_ITEM

feature {ANY}
   time: INTEGER_64
   xuplet_numerator  : INTEGER
   xuplet_denominator: INTEGER

   note: MIXUP_NOTE
   instrument: FIXED_STRING

feature {ANY}
   set (a_instrument: FIXED_STRING; a_time: like time; a_note: like note) is
      do
         xuplet(a_instrument, a_time, a_note, 1, 1)
      end

   xuplet (a_instrument: FIXED_STRING; a_time: like time; a_note: like note; a_xuplet_numerator: like xuplet_numerator; a_xuplet_denominator: like xuplet_denominator) is
      do
         instrument := a_instrument
         time := a_time
         note := a_note
         xuplet_numerator := a_xuplet_numerator
         xuplet_denominator := a_xuplet_denominator
      end

end
