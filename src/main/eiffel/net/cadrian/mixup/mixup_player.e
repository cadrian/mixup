deferred class MIXUP_PLAYER
-- just a VISITOR with a fancy name (viz. an Acyclic Visitor)
--
-- see also MIXUP_CORE_PLAYER

feature {ANY}
   play (a_event: MIXUP_EVENT) is
      require
         a_event /= Void
      do
         a_event.fire(Current)
      end

end
