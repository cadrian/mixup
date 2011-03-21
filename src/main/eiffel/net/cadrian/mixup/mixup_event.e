deferred class MIXUP_EVENT
-- just a VISITABLE with a fancy name

inherit
   COMPARABLE

feature {ANY}
   infix "<" (other: MIXUP_EVENT): BOOLEAN is
      do
         Result := time < other.time
      end

   time: INTEGER_64 is
      deferred
      end

   allow_lyrics: BOOLEAN is
      deferred
      end

   has_lyrics: BOOLEAN is
      deferred
      ensure
         not allow_lyrics implies not Result
      end

   set_has_lyrics (enable: BOOLEAN) is
      require
         allow_lyrics
         lyrics = Void
      deferred
      ensure
         has_lyrics = enable
      end

   set_lyrics (a_lyrics: like lyrics) is
      require
         has_lyrics
         a_lyrics /= Void
         lyrics = Void
      deferred
      ensure
         lyrics = a_lyrics
      end

   lyrics: TRAVERSABLE[FIXED_STRING] is
      require
         allow_lyrics
      deferred
      end

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      require
         player /= Void
      deferred
      end

end
