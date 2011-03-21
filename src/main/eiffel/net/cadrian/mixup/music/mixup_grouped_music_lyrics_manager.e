class MIXUP_GROUPED_MUSIC_LYRICS_MANAGER

create {MIXUP_GROUPED_MUSIC}
   make

feature {MIXUP_GROUPED_MUSIC}
   manage_lyrics (context: MIXUP_EVENTS_ITERATOR_CONTEXT; event: MIXUP_EVENT): MIXUP_EVENT is
      do
         Result := event
         if Result.allow_lyrics then
            Result.set_has_lyrics(has_lyrics)
            has_lyrics := allow_lyrics
         end
      end

feature {}
   make (a_allow_lyrics: like allow_lyrics) is
      do
         allow_lyrics := a_allow_lyrics
         has_lyrics := True
      ensure
         allow_lyrics = a_allow_lyrics
      end

   allow_lyrics: BOOLEAN
   has_lyrics: BOOLEAN

end
