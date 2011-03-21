class MIXUP_MIXER_CONDUCTOR

inherit
   MIXUP_CONTEXT_VISITOR
      redefine
         start_score, end_score,
         start_book, end_book,
         start_partitur, end_partitur,
         start_instrument, end_instrument
      end

create {ANY}
   make

feature {MIXUP_SCORE}
   start_score (a_score: MIXUP_SCORE) is
      do
         current_player.play(create {MIXUP_EVENT_SET_SCORE}.make(0, a_score.name))
         run_hook(a_score, current_player, once "at_start")
      end

   end_score (a_score: MIXUP_SCORE) is
      do
         (create {MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         run_hook(a_score, current_player, once "at_end")
         current_player.play(create {MIXUP_EVENT_END_SCORE}.make(0))
      end

feature {MIXUP_BOOK}
   start_book (a_book: MIXUP_BOOK) is
      do
         current_player.play(create {MIXUP_EVENT_SET_BOOK}.make(0, a_book.name))
         run_hook(a_book, current_player, once "at_start")
      end

   end_book (a_book: MIXUP_BOOK) is
      do
         (create {MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         run_hook(a_book, current_player, once "at_end")
         current_player.play(create {MIXUP_EVENT_END_BOOK}.make(0))
      end

feature {MIXUP_PARTITUR}
   start_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         current_player.play(create {MIXUP_EVENT_SET_PARTITUR}.make(0, a_partitur.name))
         run_hook(a_partitur, current_player, once "at_start")
      end

   end_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         (create {MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         run_hook(a_partitur, current_player, once "at_end")
         current_player.play(create {MIXUP_EVENT_END_PARTITUR}.make(0))
      end

feature {MIXUP_INSTRUMENT}
   start_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         current_player.play(create {MIXUP_EVENT_SET_INSTRUMENT}.make(0, a_instrument.name))
         run_hook(a_instrument, current_player, once "at_start")
      end

   end_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         run_hook(a_instrument, current_player, once "at_end")
      end

feature {}
   run_hook (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; hook_name: STRING) is
      local
         hook, res: MIXUP_VALUE
      do
         hook := a_context.hook(hook_name)
         if hook = Void then
            -- nothing to do
         elseif hook.is_callable then
            res := hook.call(a_context, a_player, create {FAST_ARRAY[MIXUP_VALUE]}.make(0))
            if res /= Void then
               not_yet_implemented -- error: lost result
            end
         else
            not_yet_implemented -- error: hook not callable
         end
      end

feature {}
   make (a_context: like current_context; a_player: like current_player) is
      require
         a_context /= Void
         a_player /= Void
      do
         current_context := a_context
         current_player  := a_player
         a_context.commit(a_player)
      ensure
         current_context = a_context
         current_player  = a_player
      end

   current_context: MIXUP_CONTEXT
   current_player: MIXUP_PLAYER

end
