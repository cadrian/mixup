class MIXUP_EVENT_SET_NOTE

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument: FIXED_STRING
   note: MIXUP_NOTE

   allow_lyrics: BOOLEAN is True

   has_lyrics: BOOLEAN

   set_has_lyrics (enable: BOOLEAN) is
      do
         has_lyrics := enable
      end

   set_lyrics (a_lyrics: like lyrics) is
      do
         lyrics := a_lyrics
      end

   lyrics: TRAVERSABLE[FIXED_STRING]

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_NOTE_PLAYER
         n: like note
      do
         p ::= player
         n := note
         if lyrics /= Void then
            create {MIXUP_LYRICS} n.make(note, lyrics)
         end
         p.play_set_note(instrument, n)
      end

feature {}
   make (a_time: like time; a_instrument: ABSTRACT_STRING; a_note: MIXUP_NOTE) is
      require
         a_instrument /= Void
         a_note /= Void
      do
         time := a_time
         instrument := a_instrument.intern
         note := a_note
         set_has_lyrics(True)
      ensure
         time = a_time
         instrument = a_instrument
         note = a_note
      end

invariant
   instrument /= Void
   note /= Void

end -- class MIXUP_EVENT_SET_NOTE
