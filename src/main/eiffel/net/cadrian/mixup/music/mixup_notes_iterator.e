class MIXUP_NOTES_ITERATOR

inherit
   ITERATOR[TUPLE[INTEGER_64, MIXUP_NOTE]]

create {ANY}
   make

feature {ANY}
   start is
      do
         compound.start_iteration(Current)
      end

   is_off: BOOLEAN is
      do
         Result := data = Void
      ensure
         definition: Result = (data = Void)
      end

   item: TUPLE[INTEGER_64, MIXUP_NOTE] is
      do
         Result := compound.item_iteration(Current)
      end

   next is
      do
         compound.next_iteration(Current)
      end

feature {MIXUP_COMPOUND_MUSIC}
   set_data (a_data: like data) is
      do
         data := a_data
      ensure
         data = a_date
      end

feature {}
   iterable_generation: INTEGER is 0
         -- generation not managed (the music should not change once created)

feature {}
   make (a_compound: like compound) is
      require
         a_compound /= Void
      do
         compound := a_compound
         start
      ensure
         compound = a_compound
      end

   compound: MIXUP_COMPOUND_MUSIC
   data: MIXUP_NOTES_ITERATOR_ANY_DATA

invariant
   compound /= Void

end
