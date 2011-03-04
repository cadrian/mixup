class MIXUP_BARS_MIXER

inherit
   MIXUP_CONTEXT_VISITOR
      redefine
         start_instrument
      end

create {ANY}
   make

feature {ANY}
   bars: ITERATOR[INTEGER_64] is
      do
         Result := barset.new_iterator
      end

feature {MIXUP_INSTRUMENT}
   start_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         a_instrument.do_all_bars(agent_add_bar)
      end

feature {}
   make is
      do
         create {AVL_SET[INTEGER_64]} barset.make
         agent_add_bar := agent add_bar
      end

   barset: SET[INTEGER_64]

   agent_add_bar: PROCEDURE[TUPLE[INTEGER_64]]

   add_bar (bar: INTEGER_64) is
      do
         barset.add(bar)
      end

invariant
   barset /= Void

end
