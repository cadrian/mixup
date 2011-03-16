deferred class MIXUP_EVENT
   -- just a VISITABLE with a fancy name

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      require
         player /= Void
      deferred
      end

end
