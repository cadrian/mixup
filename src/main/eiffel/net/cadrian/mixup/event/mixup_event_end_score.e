class MIXUP_EVENT_END_SCORE

inherit
   MIXUP_EVENT

creation {ANY}
   make

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_END_SCORE_PLAYER
      do
         p ::= player
         p.play_end_score
      end

feature {}
   make is
      do
      end

end -- class MIXUP_EVENT_END_SCORE
