-- This file is part of MiXuP.
--
-- MiXuP is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, version 3 of the License.
--
-- MiXuP is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with MiXuP.  If not, see <http://www.gnu.org/licenses/>.
--
class MIXUP_MIXER_CONDUCTOR

inherit
   MIXUP_CONTEXT_VISITOR
      redefine
         start_score, end_score,
         start_book, end_book,
         start_partitur, end_partitur,
         visit_instrument
      end

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {MIXUP_SCORE}
   start_score (a_score: MIXUP_SCORE) is
      do
         run_hook(a_score, current_player, once "at_start")
         current_player.play(create {MIXUP_EVENT_SET_SCORE}.make(a_score.source, 0, a_score.name))
      end

   end_score (a_score: MIXUP_SCORE) is
      do
         (create {MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         current_player.play(create {MIXUP_EVENT_END_SCORE}.make(a_score.source, 0))
         run_hook(a_score, current_player, once "at_end")
      end

feature {MIXUP_BOOK}
   start_book (a_book: MIXUP_BOOK) is
      do
         run_hook(a_book, current_player, once "at_start")
         current_player.play(create {MIXUP_EVENT_SET_BOOK}.make(a_book.source, 0, a_book.name))
      end

   end_book (a_book: MIXUP_BOOK) is
      do
         (create {MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         current_player.play(create {MIXUP_EVENT_END_BOOK}.make(a_book.source, 0))
         run_hook(a_book, current_player, once "at_end")
      end

feature {MIXUP_PARTITUR}
   start_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         run_hook(a_partitur, current_player, once "at_start")
         current_player.play(create {MIXUP_EVENT_SET_PARTITUR}.make(a_partitur.source, 0, a_partitur.name))
      end

   end_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         (create {MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         current_player.play(create {MIXUP_EVENT_END_PARTITUR}.make(a_partitur.source, 0))
         run_hook(a_partitur, current_player, once "at_end")
      end

feature {MIXUP_INSTRUMENT}
   visit_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         run_hook(a_instrument, current_player, once "at_start")
         current_player.play(create {MIXUP_EVENT_SET_INSTRUMENT}.make(a_instrument.source, 0, a_instrument.name))
         run_hook(a_instrument, current_player, once "at_end")
      end

feature {}
   run_hook (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER; hook_name: STRING) is
      local
         hook, res: MIXUP_VALUE
      do
         hook := a_context.hook(hook_name, a_player)
         if hook = Void then
            -- nothing to do
         elseif hook.is_callable then
            res := hook.call(a_player, create {FAST_ARRAY[MIXUP_VALUE]}.make(0))
            if res /= Void then
               warning_at(a_context.source, "lost result")
            end
         else
            fatal_at(a_context.source, "hook not callable")
         end
      end

feature {}
   make (a_context: like current_context; a_player: like current_player; start_bar_number: INTEGER) is
      require
         a_context /= Void
         a_player /= Void
      do
         current_context := a_context
         current_player  := a_player
         a_context.commit(a_player, start_bar_number)
      ensure
         current_context = a_context
         current_player  = a_player
      end

   current_context: MIXUP_CONTEXT
   current_player: MIXUP_PLAYER

end -- class MIXUP_MIXER_CONDUCTOR
