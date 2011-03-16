class MIXUP_MUSIC_IDENTIFIER

inherit
   MIXUP_MUSIC

create {ANY}
   make

feature {ANY}
   duration: INTEGER_64 is
      do
         Result := music.duration
      end

   valid_anchor: BOOLEAN is
      do
         Result := music /= Void
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := music.anchor
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      local
         music_value: MIXUP_MUSIC_VALUE
         value: MIXUP_VALUE
      do
         value := a_context.resolver.resolve(identifier, a_player)
         if value = Void then
            not_yet_implemented -- error: unresolved identifier
         elseif music_value ?:= value then
            music_value ::= value
            music := music_value.value
         else
            not_yet_implemented -- error: the identifier is not music!
         end
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         Result := music.new_events_iterator(a_context)
      end

   has_lyrics: BOOLEAN is
      do
         Result := music.has_lyrics
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
         music.consolidate_bars(bars, duration_offset)
      end

feature {}
   make (a_identifier: MIXUP_IDENTIFIER) is
      require
         a_identifier /= Void
      do
         identifier := a_identifier
      ensure
         identifier = a_identifier
      end

   identifier: MIXUP_IDENTIFIER
   music: MIXUP_MUSIC

invariant
   identifier /= Void

end
