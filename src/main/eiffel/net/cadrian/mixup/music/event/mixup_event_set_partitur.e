class MIXUP_EVENT_SET_PARTITUR

inherit
   MIXUP_EVENT_WITHOUT_LYRICS

creation {ANY}
   make

feature {ANY}
   time: INTEGER_64
   name: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_PARTITUR_PLAYER
      do
         p ::= player
         p.play_set_partitur(name)
      end

feature {}
   make (a_time: like time; a_name: ABSTRACT_STRING) is
      require
         a_name /= Void
      do
         time := a_time
         name := a_name.intern
      ensure
         time = a_time
         name = a_name
      end

invariant
   name /= Void

end -- class MIXUP_EVENT_SET_PARTITUR
