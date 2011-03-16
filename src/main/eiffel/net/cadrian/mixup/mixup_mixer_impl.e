class MIXUP_MIXER_IMPL

inherit
   MIXUP_MIXER
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
   play_context (a_context: MIXUP_CONTEXT) is
      require
         a_context /= Void
      do
         players.do_all(agent play_music_in_context(a_context, ?))
      end

   play_music_in_context (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER) is
      require
         a_context /= Void
         a_player /= Void
      do
         a_context.accept(create {MIXUP_MIXER_CONDUCTOR}.make(a_context, a_player))
      end

feature {}
   native_repeat (context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
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

   native_bar (context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
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

   event_start_repeat (player: MIXUP_PLAYER; context: MIXUP_EVENTS_ITERATOR_CONTEXT; volte: INTEGER_64) is
      do
         player.start_repeat(context.instrument.name, volte)
      end

   event_end_repeat (player: MIXUP_PLAYER; context: MIXUP_EVENTS_ITERATOR_CONTEXT) is
      do
         player.end_repeat(context.instrument.name)
      end

feature {ANY}
   item (name: STRING): FUNCTION[TUPLE[MIXUP_CONTEXT, MIXUP_PLAYER, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE] is
      do
         inspect
            name
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
