expanded class MIXUP_NOTES_ITERATOR_ITEM

feature {ANY}
   time: INTEGER_64
   xuplet_numerator  : INTEGER
   xuplet_denominator: INTEGER

   note: MIXUP_NOTE
   instrument: FIXED_STRING

   with_lyrics: BOOLEAN

feature {ANY}
   set_note (a_note: like note) is
      do
         note := a_note
      end

   set (a_instrument: FIXED_STRING; a_time: like time; a_note: like note; a_lyrics: like with_lyrics) is
      do
         xuplet(a_instrument, a_time, a_note, 1, 1, a_lyrics)
      end

   xuplet (a_instrument: FIXED_STRING; a_time: like time; a_note: like note; a_xuplet_numerator: like xuplet_numerator; a_xuplet_denominator: like xuplet_denominator; a_lyrics: like with_lyrics) is
      do
         instrument := a_instrument
         time := a_time
         note := a_note
         xuplet_numerator := a_xuplet_numerator
         xuplet_denominator := a_xuplet_denominator
         with_lyrics := a_lyrics
      end

end
