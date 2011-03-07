class MIXUP_MIXER_IMPL

inherit
   MIXUP_MIXER
   MIXUP_CONTEXT_VISITOR
      redefine
         start_score, end_score,
         start_book, end_book,
         start_partitur, end_partitur,
         start_instrument, end_instrument
      end
   MIXUP_VALUE_VISITOR
   MIXUP_EVENTS

create {ANY}
   make

feature {ANY}
   play is
      do
         contexts.do_all(agent play_context)
      end

   add_piece (a_piece: MIXUP_NODE) is
      require
         a_piece /= Void
      local
         context: MIXUP_CONTEXT
      do
         context := parser.parse(a_piece)
         if contexts.has(context.name) then
            not_yet_implemented -- error: duplicate context name
         else
            contexts.add(context, context.name)
         end
      end

   add_player (a_player: MIXUP_PLAYER) is
      require
         a_player /= Void
      do
         players.add_last(a_player)
      end

feature {}
   current_context: MIXUP_CONTEXT

   play_context (a_context: like current_context) is
      require
         a_context /= Void
      do
         current_context := a_context
         a_context.accept(Current)
      end

feature {MIXUP_SCORE}
   start_score (a_score: MIXUP_SCORE) is
      do
         fire_set_score(a_score.name)
         a_score.run_hook(once "at_start", Current)
      end

   end_score (a_score: MIXUP_SCORE) is
      do
         a_score.run_hook(once "at_end", Current)
         fire_end_score
      end

feature {MIXUP_BOOK}
   start_book (a_book: MIXUP_BOOK) is
      do
         fire_set_book(a_book.name)
         a_book.run_hook(once "at_start", Current)
      end

   end_book (a_book: MIXUP_BOOK) is
      do
         a_book.run_hook(once "at_end", Current)
         fire_end_book
      end

feature {MIXUP_PARTITUR}
   start_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         fire_set_partitur(a_partitur.name)
         a_partitur.run_hook(once "at_start", Current)
      end

   end_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         a_partitur.run_hook(once "at_end", Current)
         fire_end_partitur
      end

feature {MIXUP_INSTRUMENT}
   start_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         a_instrument.run_hook(once "at_start", Current)
         fire_set_instrument(a_instrument.name)
      end

   end_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         a_instrument.run_hook(once "at_end", Current)
      end

feature {MIXUP_BOOLEAN}
   visit_boolean (a_boolean: MIXUP_BOOLEAN) is
      do
      end

feature {MIXUP_IDENTIFIER}
   visit_identifier (a_identifier: MIXUP_IDENTIFIER) is
      do
      end

feature {MIXUP_INTEGER}
   visit_integer (a_integer: MIXUP_INTEGER) is
      do
      end

feature {MIXUP_REAL}
   visit_real (a_real: MIXUP_REAL) is
      do
      end

feature {MIXUP_STRING}
   visit_string (a_string: MIXUP_STRING) is
      do
      end

feature {MIXUP_NATIVE_FUNCTION}
   visit_native_function (a_function: MIXUP_NATIVE_FUNCTION) is
      do
         inspect
            a_function.name
         when "print" then
            native_print
         when "play_musixtex" then
            native_play_musixtex
         when "play_midi" then
            native_play_midi
         else
            not_yet_implemented -- error: unknown native function
         end
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
      end

feature {}
   native_play_musixtex is
      once
         add_player(create {MIXUP_MUSIXTEX_PLAYER}.make)
      end

   native_play_midi is
      once
         --add_player(create {MIXUP_MIDI_PLAYER}.make)
      end

   native_print is
      local
         bars: ITERATOR[INTEGER_64]
         bars_mixer: MIXUP_BARS_MIXER
         notes: MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS
      do
         create bars_mixer.make
         current_context.accept(bars_mixer)
         bars := bars_mixer.bars

         from
            create notes.make(current_context)
            fire_start_bar
         until
            notes.is_off
         loop
            if not bars.is_off and then bars.item <= notes.item.time then
               fire_end_bar
               fire_start_bar
               bars.next
            end
            notes.item.fire_event(Current)
            notes.next
         end
         fire_end_bar
      end

feature {ANY}
   fire_set_book (book_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_book(book_name))
      end

   fire_end_book is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_book);
      end

   fire_set_score (score_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_score(score_name))
      end

   fire_end_score is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_score);
      end

   fire_set_partitur (partitur_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_partitur(partitur_name))
      end

   fire_end_partitur is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_partitur);
      end

   fire_set_instrument (instrument_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_instrument(instrument_name))
      end

   fire_set_dynamics (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; dynamics, position: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_dynamics(instrument_name, time_start, dynamics, position))
      end

   fire_set_note (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_note(instrument_name, time_start, note));
      end

   fire_start_bar is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_bar);
      end

   fire_end_bar is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_bar);
      end

   fire_start_beam (instrument: ABSTRACT_STRING; text: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_beam(instrument, text));
      end

   fire_end_beam (instrument: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_beam(instrument));
      end

   fire_start_slur (instrument: ABSTRACT_STRING; text: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_slur(instrument, text));
      end

   fire_end_slur (instrument: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_slur(instrument));
      end

   fire_start_tie (instrument: ABSTRACT_STRING; text: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_tie(instrument, text));
      end

   fire_end_tie (instrument: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_tie(instrument));
      end

feature {}
   parser: MIXUP_PARSER
   players: COLLECTION[MIXUP_PLAYER]
   contexts: DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]

   make is
      do
         create parser.make
         create {FAST_ARRAY[MIXUP_PLAYER]} players.make(0)
         create {HASHED_DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]} contexts.make
      end

invariant
   parser /= Void
   players /= Void
   contexts /= Void

end
