class MIXUP_DECORATED_MUSIC

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
         Result := music.valid_anchor
      end

   anchor: MIXUP_NOTE_HEAD is
      do
         Result := music.anchor
      end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      do
         music.commit(a_context, a_player)
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_NOTES_ITERATOR_ON_DECORATED_MUSIC} Result.make(a_context, start_event, end_event, music.new_events_iterator(a_context))
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
   make (a_music: like music; a_start_event: like start_event; a_end_event: like end_event) is
      require
         a_music /= Void
      do
         music := a_music
         start_event := a_start_event
         end_event := a_end_event
      ensure
         music = a_music
         start_event = a_start_event
         end_event = a_end_event
      end

   music: MIXUP_MUSIC
   start_event: PROCEDURE[TUPLE[MIXUP_PLAYER, MIXUP_EVENTS_ITERATOR_CONTEXT]]
   end_event: PROCEDURE[TUPLE[MIXUP_PLAYER, MIXUP_EVENTS_ITERATOR_CONTEXT]]

invariant
   music /= Void

end
