class MIXUP_BAR

inherit
   MIXUP_MUSIC

insert
   LOGGING

create {ANY}
   make

feature {ANY}
   style: FIXED_STRING

   valid_anchor: BOOLEAN is False

   duration: INTEGER_64 is 0
   anchor: MIXUP_NOTE_HEAD is do end

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      do
         debug
            log.trace.put_line("Committing bar: " + out)
         end
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_EVENT_NEXT_BAR}.make(a_context.start_time, a_context.instrument.name, style))
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   frozen consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
         bars.add(duration_offset)
      end

feature {}
   make (a_style: like style) is
      do
         style := a_style
      ensure
         style = a_style
      end

end
