expanded class MIXUP_NOTES_ITERATOR_CONTEXT

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

   set_instrument (a_instrument: like instrument) is
      do
         instrument := a_instrument
      end

   add_time (duration: INTEGER_64) is
      do
         start_time := start_time + duration
      end

feature {}
   default_create is
      do
         instrument := Void
         start_time := 0
      end

end
