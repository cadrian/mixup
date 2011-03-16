deferred class MIXUP_EVENT_SET_DYNAMICS_PLAYER

inherit
   MIXUP_PLAYER

feature {MIXUP_EVENT_SET_DYNAMICS}
   play_set_dynamics (a_instrument_name: ABSTRACT_STRING; a_dynamics: ABSTRACT_STRING; a_position: ABSTRACT_STRING) is
      require
         a_instrument_name /= Void
         a_dynamics /= Void
      deferred
      end

end -- class MIXUP_EVENT_SET_DYNAMICS_PLAYER
