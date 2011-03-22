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
class MIXUP_MIXER_IMPL

inherit
   MIXUP_MIXER
   MIXUP_NATIVE_PROVIDER

insert
   LOGGING

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
            create decorated.make(once "repeat", music.value,
                                  agent event_start_repeat(?, volte.value),
                                  agent event_end_repeat,
                                  Void)
            create {MIXUP_MUSIC_VALUE} Result.make(decorated)
         end
      end

   native_with_lyrics (context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         music: MIXUP_MUSIC_VALUE
         instr: MIXUP_INSTRUMENT
         decorated: MIXUP_DECORATED_MUSIC
      do
         if args.count /= 1 then
            not_yet_implemented -- error: bad argument count
         elseif not (music ?:= args.first) then
            not_yet_implemented -- error: bad argument type
         else
            music ::= args.first
            instr ::= context
            create decorated.make(once "with_lyrics", music.value,
                                  Void, Void,
                                  agent force_lyrics)
            create {MIXUP_MUSIC_VALUE} Result.make(decorated)
         end
      end

   force_lyrics (context: MIXUP_EVENTS_ITERATOR_CONTEXT; event: MIXUP_EVENT): MIXUP_EVENT is
      do
         Result := event
         if Result.allow_lyrics then
            Result.set_has_lyrics(True)
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

   event_start_repeat (context: MIXUP_EVENTS_ITERATOR_CONTEXT; volte: INTEGER_64): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_START_REPEAT} Result.make(context.start_time, context.instrument.name, volte)
      end

   event_end_repeat (context: MIXUP_EVENTS_ITERATOR_CONTEXT): MIXUP_EVENT is
      do
         create {MIXUP_EVENT_END_REPEAT} Result.make(context.start_time, context.instrument.name)
      end

feature {ANY}
   item (name: STRING): FUNCTION[TUPLE[MIXUP_CONTEXT, MIXUP_PLAYER, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE] is
      do
         log.trace.put_line("Preparing native function: " + name)
         inspect
            name
         when "repeat" then
            Result := agent native_repeat
         when "bar" then
            Result := agent native_bar
         when "with_lyrics" then
            Result := agent native_with_lyrics
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

end -- class MIXUP_MIXER_IMPL
