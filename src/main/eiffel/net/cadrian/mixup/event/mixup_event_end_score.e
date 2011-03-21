class MIXUP_EVENT_END_SCORE

inherit
   MIXUP_EVENT_WITHOUT_LYRICS

creation {ANY}
   make

feature {ANY}
   time: INTEGER_64

feature {MIXUP_PLAYER}
   fire (player: MIXUP_PLAYER) is
      local
         p: MIXUP_EVENT_END_SCORE_PLAYER
      do
         p ::= player
         p.play_end_score
      end

feature {}
   make (a_time: like time) is
      do
         time := a_time
      ensure
         time = a_time
      end

end -- class MIXUP_EVENT_END_SCORE
