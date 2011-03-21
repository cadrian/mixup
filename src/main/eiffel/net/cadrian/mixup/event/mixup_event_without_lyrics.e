deferred class MIXUP_EVENT_WITHOUT_LYRICS

inherit
   MIXUP_EVENT

feature {ANY}
   allow_lyrics: BOOLEAN is False
   has_lyrics: BOOLEAN is False

   set_has_lyrics (enable: BOOLEAN) is
      do
         crash
      end

   set_lyrics (a_lyrics: like lyrics) is
      do
         crash
      end

   lyrics: TRAVERSABLE[FIXED_STRING] is
      do
         check Result = Void end
      end

end -- class MIXUP_EVENT_WITHOUT_LYRICS
