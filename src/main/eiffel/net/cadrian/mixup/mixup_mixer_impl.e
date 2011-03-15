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
   MIXUP_NATIVE_PROVIDER

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
         run_hook(a_score, once "at_start")
      end

   end_score (a_score: MIXUP_SCORE) is
      do
         run_hook(a_score, once "at_end")
         fire_end_score
      end

feature {MIXUP_BOOK}
   start_book (a_book: MIXUP_BOOK) is
      do
         fire_set_book(a_book.name)
         run_hook(a_book, once "at_start")
      end

   end_book (a_book: MIXUP_BOOK) is
      do
         run_hook(a_book, once "at_end")
         fire_end_book
      end

feature {MIXUP_PARTITUR}
   start_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         fire_set_partitur(a_partitur.name)
         run_hook(a_partitur, once "at_start")
      end

   end_partitur (a_partitur: MIXUP_PARTITUR) is
      do
         run_hook(a_partitur, once "at_end")
         fire_end_partitur
      end

feature {MIXUP_INSTRUMENT}
   start_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         fire_set_instrument(a_instrument.name)
         run_hook(a_instrument, once "at_start")
      end

   end_instrument (a_instrument: MIXUP_INSTRUMENT) is
      do
         run_hook(a_instrument, once "at_end")
      end

feature {}
   run_hook (a_context: MIXUP_CONTEXT; hook_name: STRING) is
      local
         hook, res: MIXUP_VALUE
      do
         hook := a_context.hook(hook_name, Current)
         if hook = Void then
            -- nothing to do
         elseif hook.is_callable then
            res := hook.call(a_context, create {FAST_ARRAY[MIXUP_VALUE]}.make(0))
            if res /= Void then
               not_yet_implemented -- error: lost result
            end
         else
            not_yet_implemented -- error: hook not callable
         end
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
      end

feature {MIXUP_USER_FUNCTION}
   visit_user_function (a_function: MIXUP_USER_FUNCTION) is
      do
      end

feature {MIXUP_MUSIC_VALUE}
   visit_music (a_music: MIXUP_MUSIC_VALUE) is
      do
      end

feature {}
   native_play_lilypond (context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      once
         add_player(create {MIXUP_LILYPOND_PLAYER}.make)
      end

   native_play_musixtex (context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      once
         --add_player(create {MIXUP_MUSIXTEX_PLAYER}.make)
      end

   native_play_midi (context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      once
         --add_player(create {MIXUP_MIDI_PLAYER}.make)
      end

   native_repeat (context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         volte: MIXUP_INTEGER
         music: MIXUP_MUSIC_VALUE
         instr: MIXUP_INSTRUMENT
         decorated: MIXUP_DECORATED_MUSIC
      do
         if args.count /= 2 then
            not_yet_implemented -- error: bad argument count
         elseif not (volte ?:= args.first) or else not (music ?:= args.last) then
            not_yet_implemented -- error: bad argument type
         else
            volte ::= args.first
            music ::= args.last
            instr ::= context
            create decorated.make(music.value,
                                  agent event_start_repeat(?, ?, volte.value),
                                  agent event_end_repeat)
            create {MIXUP_MUSIC_VALUE} Result.make(decorated)
         end
      end

   native_bar (context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         string: MIXUP_STRING
      do
         if args.count /= 1 then
            not_yet_implemented -- error: bad argument count
         elseif not (string ?:= args.first) then
            not_yet_implemented -- error: bad argument type
         else
            string ::= args.first
            create {MIXUP_MUSIC_VALUE} Result.make(create {MIXUP_BAR}.make(string.value))
         end
      end

   event_start_repeat (events: MIXUP_EVENTS; context: MIXUP_EVENTS_ITERATOR_CONTEXT; volte: INTEGER_64) is
      do
         check events = Current end
         fire_start_repeat(context.instrument.name, volte)
      end

   event_end_repeat (events: MIXUP_EVENTS; context: MIXUP_EVENTS_ITERATOR_CONTEXT) is
      do
         check events = Current end
         fire_end_repeat(context.instrument.name)
      end

   native_play (context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         (create {MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS}.make(current_context)).do_all(agent {MIXUP_EVENTS_ITERATOR_ITEM}.fire_event(Current))
      end

feature {ANY}
   fire_set_book (book_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_book(book_name))
      end

   fire_end_book is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_book)
      end

   fire_set_score (score_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_score(score_name))
      end

   fire_end_score is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_score)
      end

   fire_set_partitur (partitur_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_partitur(partitur_name))
      end

   fire_end_partitur is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_partitur)
      end

   fire_set_instrument (instrument_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_instrument(instrument_name))
      end

   fire_set_dynamics (instrument_name, dynamics, position: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_dynamics(instrument_name, dynamics, position))
      end

   fire_set_note (instrument_name: ABSTRACT_STRING; note: MIXUP_NOTE) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_note(instrument_name, note))
      end

   fire_next_bar (instrument_name, style: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.next_bar(instrument_name, style))
      end

   fire_start_beam (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_beam(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   fire_end_beam (instrument: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_beam(instrument))
      end

   fire_start_slur (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_slur(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   fire_end_slur (instrument: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_slur(instrument))
      end

   fire_start_tie (instrument: ABSTRACT_STRING; xuplet_numerator, xuplet_denominator: INTEGER_64; text: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_tie(instrument, xuplet_numerator, xuplet_denominator, text))
      end

   fire_end_tie (instrument: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_tie(instrument))
      end

   fire_start_repeat (instrument: ABSTRACT_STRING; volte: INTEGER_64) is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_repeat(instrument, volte))
      end

   fire_end_repeat (instrument: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_repeat(instrument))
      end

feature {ANY}
   item (name: STRING): FUNCTION[TUPLE[MIXUP_CONTEXT, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE] is
      do
         inspect
            name
         when "play" then
            Result := agent native_play
         when "play_lilypond" then
            Result := agent native_play_lilypond
         when "play_musixtex" then
            not_yet_implemented -- error: back-end not ready to be used
            Result := agent native_play_musixtex
         when "play_midi" then
            not_yet_implemented -- error: back-end not ready to be used
            Result := agent native_play_midi
         when "repeat" then
            Result := agent native_repeat
         when "bar" then
            Result := agent native_bar
         else
            not_yet_implemented -- error: unknown native function
         end
      end

feature {}
   parser: MIXUP_PARSER
   players: COLLECTION[MIXUP_PLAYER]
   contexts: DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]

   make is
      do
         create parser.make(Current)
         create {FAST_ARRAY[MIXUP_PLAYER]} players.make(0)
         create {HASHED_DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]} contexts.make
      end

invariant
   parser /= Void
   players /= Void
   contexts /= Void

end
