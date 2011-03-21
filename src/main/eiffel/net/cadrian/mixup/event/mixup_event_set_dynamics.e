class MIXUP_EVENT_SET_DYNAMICS

inherit
   MIXUP_EVENT_WITHOUT_LYRICS

creation {ANY}
   make

feature {ANY}
   time: INTEGER_64
   instrument_name: FIXED_STRING
   dynamics: FIXED_STRING
   position: FIXED_STRING

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_SET_DYNAMICS_PLAYER
      do
         p ::= player
         p.play_set_dynamics(instrument_name, dynamics, position)
      end

feature {}
   make (a_time: like time; a_instrument_name: ABSTRACT_STRING; a_dynamics: ABSTRACT_STRING; a_position: ABSTRACT_STRING) is
      require
         a_instrument_name /= Void
         a_dynamics /= Void
      do
         time := a_time
         instrument_name := a_instrument_name.intern
         dynamics := a_dynamics.intern
         if a_position /= Void then
            position := a_position.intern
         end
      ensure
         time = a_time
         instrument_name = a_instrument_name
         dynamics = a_dynamics
         position = a_position
      end

invariant
   instrument_name /= Void
   dynamics /= Void

end -- class MIXUP_EVENT_SET_DYNAMICS
