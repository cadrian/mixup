deferred class MIXUP_EVENT_END_BEAM_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_END_BEAM}
   play_end_beam (a_instrument: ABSTRACT_STRING) is
      require
         a_instrument /= Void
      deferred
      end

end -- class MIXUP_EVENT_END_BEAM_PLAYER
