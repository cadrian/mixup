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

feature {ANY}
   play is
      do
         check
            level = 0
         end
         current_context.accept(Current)
      end

feature {MIXUP_SCORE}
   start_score (a_score: MIXUP_SCORE) is
      do
         level := level + 1
         a_score.run_hook(a_score.source, current_player, once "at_start")
         current_player.play(create {MIXUP_EVENT_SET_SCORE}.make(a_score.source, 0, a_score.name))
         a_score.run_hook(a_score.source, current_player, once "at_score_start")
      end

   end_score (a_score: MIXUP_SCORE) is
      do
         (create {MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         a_score.run_hook(a_score.source, current_player, once "at_score_end")
         current_player.play(create {MIXUP_EVENT_END_SCORE}.make(a_score.source, 0))
         a_score.run_hook(a_score.source, current_player, once "at_end")
         level := level - 1
      end

feature {MIXUP_BOOK}
   start_book (a_book: MIXUP_BOOK) is
      do
         level := level + 1
         a_book.run_hook(a_book.source, current_player, once "at_start")
         current_player.play(create {MIXUP_EVENT_SET_BOOK}.make(a_book.source, 0, a_book.name))
         a_book.run_hook(a_book.source, current_player, once "at_book_start")
      end

   end_book (a_book: MIXUP_BOOK) is
      do
         (create {MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         a_book.run_hook(a_book.source, current_player, once "at_book_end")
         current_player.play(create {MIXUP_EVENT_END_BOOK}.make(a_book.source, 0))
         a_book.run_hook(a_book.source, current_player, once "at_end")
         level := level - 1
      end

feature {MIXUP_PARTITUR}
   start_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         level := level + 1
         a_partitur.run_hook(a_partitur.source, current_player, once "at_start")
         current_player.play(create {MIXUP_EVENT_SET_PARTITUR}.make(a_partitur.source, 0, a_partitur.name))
         a_partitur.run_hook(a_partitur.source, current_player, once "at_partitur_start")
      end

   end_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         (create {MIXUP_EVENTS_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent current_player.play)
         a_partitur.run_hook(a_partitur.source, current_player, once "at_partitur_end")
         current_player.play(create {MIXUP_EVENT_END_PARTITUR}.make(a_partitur.source, 0))
         a_partitur.run_hook(a_partitur.source, current_player, once "at_end")
         level := level - 1
      end

feature {MIXUP_INSTRUMENT}
   visit_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         if not top_level then
            current_player.set_context(a_instrument)
            a_instrument.run_hook(a_instrument.source, current_player, once "at_start")
            current_player.play(create {MIXUP_EVENT_SET_INSTRUMENT}.make(a_instrument.source, 0, a_instrument.name, a_instrument.voice_staff_ids))
            a_instrument.run_hook(a_instrument.source, current_player, once "at_end")
         end
      end

feature {}
   make (a_context: like current_context; a_player: like current_player; a_bar_number: INTEGER) is
      require
         a_context /= Void
         a_player /= Void
      do
         current_player  := a_player
         current_context := a_context.commit(a_player, a_bar_number)
      ensure
         current_player  = a_player
      end

   current_context: MIXUP_CONTEXT
   current_player: MIXUP_PLAYER

   top_level: BOOLEAN is
      do
         Result := level = 0
      end

   level: INTEGER

end -- class MIXUP_MIXER_CONDUCTOR
