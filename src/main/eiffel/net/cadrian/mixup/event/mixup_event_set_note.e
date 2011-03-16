class MIXUP_EVENT_SET_NOTE

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {ANY}
   instrument: FIXED_STRING

   note: MIXUP_NOTE

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_NOTE_PLAYER
      do
         p ::= player
         p.play_set_note(instrument, note)
      end

feature {}
   make (a_instrument: ABSTRACT_STRING; a_note: MIXUP_NOTE) is
      require
         a_instrument /= Void
      do
         instrument := a_instrument.intern
         note := a_note
      ensure
         instrument = a_instrument
         note = a_note
      end

invariant
   instrument /= Void

end -- class MIXUP_EVENT_SET_NOTE
