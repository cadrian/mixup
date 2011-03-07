expanded class MIXUP_EVENTS_ITERATOR_CONTEXT

insert
   ANY
      redefine
         default_create
      end

create {ANY}
   default_create

feature {ANY}
   instrument: MIXUP_INSTRUMENT
   start_time: INTEGER_64
   xuplet_numerator: INTEGER_64
   xuplet_denominator: INTEGER_64
   xuplet_text: FIXED_STRING

   set_instrument (a_instrument: like instrument) is
      do
         instrument := a_instrument
      end

   add_time (duration: INTEGER_64) is
      do
         start_time := start_time + duration
      end

   set_xuplet (num, den: INTEGER_64; txt: FIXED_STRING) is
      do
         xuplet_numerator := num
         xuplet_denominator := den
         xuplet_text := txt
      end

feature {}
   default_create is
      do
         instrument := Void
         start_time := 0
      end

end
