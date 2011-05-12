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
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   play is
      do
         contexts.do_all(agent play_context)
      end

   add_piece (a_piece: MIXUP_NODE; a_file: ABSTRACT_STRING) is
      require
         a_piece /= Void
         a_file /= Void
      local
         ignored: MIXUP_CONTEXT
      do
         ignored := do_add_piece(a_piece, a_file.intern)
      end

   add_player (a_player: MIXUP_PLAYER) is
      require
         a_player /= Void
      do
         players.add_last(a_player)
      end

feature {}
   do_add_piece (a_piece: MIXUP_NODE; a_file: FIXED_STRING): MIXUP_CONTEXT is
      require
         a_piece /= Void
         a_file /= Void
      do
         create {MIXUP_SOURCE_IMPL} source.make(a_piece, a_file, 0, 0)
         Result := parser.parse(a_piece, a_file, agent import_context)
         if contexts.has(Result.name) then
            warning("duplicate context name: " + Result.name)
         else
            contexts.add(Result, Result.name)
         end
      end

   import_context (a_source: like source; a_name: FIXED_STRING): MIXUP_CONTEXT is
      require
         a_source /= Void
         a_name /= Void
      local
         file: TUPLE[MIXUP_NODE, FIXED_STRING]
      do
         Result := contexts.reference_at(a_name)
         if Result = Void then
            file := file_reader.item([a_name])
            if file = Void then
               fatal_at(a_source, "Could not find module: " + a_name.out)
            else
               Result := do_add_piece(file.first, file.second)
            end
         end
      end

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
         a_context.accept(create {MIXUP_MIXER_CONDUCTOR}.make(a_context, a_player, a_context.bar_number))
      end

feature {}
   native_with_lyrics (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         music: MIXUP_MUSIC_VALUE
         decorated: MIXUP_DECORATED_MUSIC
         bar_number: INTEGER
      do
         if args.count /= 1 then
            error_at(a_source, "bad argument count")
         elseif not (music ?:= args.first) then
            error_at(args.first.source, "bad argument type")
         else
            music ::= args.first
            create decorated.make(a_source, once "with_lyrics", music.value,
                                  Void, Void,
                                  agent force_lyrics(a_source, ?, ?))
            bar_number := decorated.commit(context, player, context.bar_number)
            context.set_bar_number(bar_number)
            create {MIXUP_MUSIC_VALUE} Result.make(a_source, decorated)
         end
      end

   force_lyrics (a_source: MIXUP_SOURCE; context: MIXUP_EVENTS_ITERATOR_CONTEXT; event: MIXUP_EVENT): MIXUP_EVENT is
      do
         Result := event
         if Result.allow_lyrics then
            Result.set_has_lyrics(True)
         end
      end

   native_bar (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         string: MIXUP_STRING
         bar: MIXUP_BAR
         bar_number: INTEGER
      do
         if args.count /= 1 then
            error_at(a_source, "bad argument count")
         elseif not (string ?:= args.first) then
            error_at(args.first.source, "bad argument type")
         else
            string ::= args.first
            create bar.make(a_source, string.value)
            bar_number := bar.commit(context, player, context.bar_number)
            context.set_bar_number(bar_number)
            create {MIXUP_MUSIC_VALUE} Result.make(a_source, bar)
         end
      end

   native_seq (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         low, up: MIXUP_INTEGER
      do
         if args.count /= 2 then
            error_at(a_source, "bad argument count")
         elseif not (low ?:= args.first) then
            error_at(args.first.source, "bad argument")
         elseif not (up ?:= args.last) then
            error_at(args.last.source, "bad argument")
         else
            low ::= args.first
            up ::= args.last
            create {MIXUP_SEQ} Result.make(a_source, low, up)
         end
      end

   native_new_music_store (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         create {MIXUP_MUSIC_STORE} Result.make(a_source)
      end

   native_store_music (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      local
         music_store: MIXUP_MUSIC_STORE
         music: MIXUP_MUSIC_VALUE
         bar_number: INTEGER
      do
         if args.count /= 2 then
            error_at(a_source, "bad argument count")
         elseif not (music_store ?:= args.first) then
            error_at(args.first.source, "bad argument")
         elseif not (music ?:= args.last) then
            error_at(args.last.source, "bad argument")
         else
            music_store ::= args.first
            if not music_store.has_voice then
               music_store.next_voice(a_source)
            end
            music ::= args.last
            music_store.add_music(music.value)
            bar_number := music_store.commit(context, player, context.bar_number)
            context.set_bar_number(bar_number)
         end
      end

   native_store_text (a_source: MIXUP_SOURCE; context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
      end

   native_in_player (a_source: MIXUP_SOURCE; name: STRING; context: MIXUP_CONTEXT; player: MIXUP_PLAYER; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
      do
         Result := player.native(a_source, name, context, args)
      end

feature {ANY}
   item (a_source: like source; name: STRING): FUNCTION[TUPLE[MIXUP_CONTEXT, MIXUP_PLAYER, TRAVERSABLE[MIXUP_VALUE]], MIXUP_VALUE] is
      do
         log.trace.put_line("Preparing native function: " + name)
         inspect
            name
         when "bar" then
            Result := agent native_bar(a_source, ?, ?, ?)
         when "with_lyrics" then
            Result := agent native_with_lyrics(a_source, ?, ?, ?)
         when "seq" then
            Result := agent native_seq(a_source, ?, ?, ?)
         when "new_music_store" then
            Result := agent native_new_music_store(a_source, ?, ?, ?)
         when "store_music" then
            Result := agent native_store_music(a_source, ?, ?, ?)
         when "store_text" then
            Result := agent native_store_text(a_source, ?, ?, ?)
         else
            Result := agent native_in_player(a_source, name, ?, ?, ?)
         end
      end

feature {}
   parser: MIXUP_PARSER
   players: COLLECTION[MIXUP_PLAYER]
   contexts: DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]
   file_reader: FUNCTION[TUPLE[FIXED_STRING], TUPLE[MIXUP_NODE, FIXED_STRING]]

   make (a_file_reader: like file_reader) is
      require
         a_file_reader /= Void
      do
         create parser.make(create {MIXUP_SEED_PLAYER}.make(Current), Current)
         create {FAST_ARRAY[MIXUP_PLAYER]} players.make(0)
         create {LINKED_HASHED_DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]} contexts.make
         file_reader := a_file_reader
      ensure
         file_reader = a_file_reader
      end

invariant
   parser /= Void
   players /= Void
   contexts /= Void
   file_reader /= Void

end -- class MIXUP_MIXER_IMPL
