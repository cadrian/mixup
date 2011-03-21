deferred class MIXUP_NOTE

inherit
   MIXUP_MUSIC

insert
   LOGGING

feature {ANY}
   valid_anchor: BOOLEAN is True

   commit (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      do
         debug
            log.trace.put_line("Committing note: " + out)
         end
      end

   new_events_iterator (a_context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENTS_ITERATOR is
      do
         create {MIXUP_SINGLE_EVENT_ITERATOR} Result.make(create {MIXUP_EVENT_SET_NOTE}.make(a_context.start_time, a_context.instrument.name, Current))
      end

feature {MIXUP_MUSIC, MIXUP_VOICE}
   frozen consolidate_bars (bars: SET[INTEGER_64]; duration_offset: like duration) is
      do
      end

end
