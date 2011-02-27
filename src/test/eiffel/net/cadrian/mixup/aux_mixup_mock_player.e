class AUX_MIXUP_MOCK_PLAYER

inherit
   MIXUP_PLAYER

insert
   AUX_MIXUP_MOCK_PLAYER_EVENTS

create {ANY}
   make

feature {ANY}
   events: TRAVERSABLE[AUX_MIXUP_MOCK_EVENT]

feature {}
   make is
      do
         create {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]} events.make(0)
      end

invariant
   events /= Void

end
