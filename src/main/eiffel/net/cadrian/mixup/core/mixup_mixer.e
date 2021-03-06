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
class MIXUP_MIXER

inherit
   MIXUP_NATIVE_PROVIDER

insert
   MIXUP_ERRORS

create {ANY}
   make

feature {ANY}
   play
      do
         contexts.do_all(agent play_context)
      end

   add_piece (a_piece: MIXUP_NODE; a_file: ABSTRACT_STRING)
      require
         a_piece /= Void
         a_file /= Void
      local
         ignored: MIXUP_CONTEXT
      do
         ignored := do_add_piece(a_piece, a_file.intern)
      end

   add_player (a_player: MIXUP_PLAYER)
      require
         a_player /= Void
      do
         players.add_last(a_player)
      end

feature {}
   do_add_piece (a_piece: MIXUP_NODE; a_file: FIXED_STRING): MIXUP_CONTEXT
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

   import_context (a_source: like source; a_name: FIXED_STRING): MIXUP_CONTEXT
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

   play_context (a_context: MIXUP_CONTEXT)
      require
         a_context /= Void
      do
         players.do_all(agent play_music_in_context(a_context, ?))
      end

   play_music_in_context (a_context: MIXUP_CONTEXT; a_player: MIXUP_PLAYER)
      require
         a_context /= Void
         a_player /= Void
      local
         context_: MIXUP_CONTEXT
         commit_context: MIXUP_COMMIT_CONTEXT
         conductor: MIXUP_MIXER_CONDUCTOR
      do
         log.info.put_line("Now playing " + a_context.name.out + " using " + a_player.name.out)

         commit_context.set_player(a_player)
         context_ := a_context.commit(commit_context)

         commit_context := context_.set_commit_context(commit_context)

         create conductor.make(commit_context)
         conductor.play
      end

feature {}
   native_with_lyrics (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         music: MIXUP_MUSIC_VALUE
         decorated: MIXUP_DECORATED_MUSIC
      do
         if context.args.count /= 1 then
            error_at(context.call_source, "bad argument count")
         elseif not (music ?:= context.args.first) then
            error_at(context.args.first.source, "bad argument type")
         else
            music ::= context.args.first
            create decorated.make(context.call_source, once "with_lyrics", music.value,
                                  Void, Void,
                                  agent force_lyrics(a_def_source, context.call_source, ?, ?))
            create {MIXUP_MUSIC_VALUE} Result.make(context.call_source, decorated.commit(context.commit_context))
         end
      end

   force_lyrics (a_def_source, a_call_source: MIXUP_SOURCE; context: MIXUP_EVENTS_ITERATOR_CONTEXT; event: MIXUP_EVENT): MIXUP_EVENT
      do
         Result := event
         if Result.allow_lyrics then
            Result.set_has_lyrics(True)
         end
      end

   native_bar (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         string: MIXUP_STRING
         bar: MIXUP_BAR
      do
         if context.args.count /= 1 then
            error_at(context.call_source, "bad argument count")
         elseif not (string ?:= context.args.first) then
            error_at(context.args.first.source, "bad argument type")
         else
            string ::= context.args.first
            create bar.make(context.call_source, string.value)
            create {MIXUP_MUSIC_VALUE} Result.make(context.call_source, bar.commit(context.commit_context))
         end
      end

   native_seq (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         low, up: MIXUP_INTEGER
      do
         if context.args.count /= 2 then
            error_at(context.call_source, "bad argument count")
         elseif not (low ?:= context.args.first) then
            error_at(context.args.first.source, "bad argument")
         elseif not (up ?:= context.args.last) then
            error_at(context.args.last.source, "bad argument")
         else
            low ::= context.args.first
            up ::= context.args.last
            create {MIXUP_SEQ} Result.make(context.call_source, low, up)
         end
      end

   native_new_music_store (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      do
         create {MIXUP_MUSIC_STORE} Result.make(context.call_source)
      end

   native_store_music (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         music_store: MIXUP_MUSIC_STORE
         evaluator: MIXUP_MUSIC_EVALUATOR
         music: MIXUP_MUSIC
      do
         if context.args.count /= 2 then
            error_at(context.call_source, "bad argument count")
         elseif not (music_store ?:= context.args.first) then
            error_at(context.args.first.source, "bad argument")
         else
            music_store ::= context.args.first
            if not music_store.has_voice then
               music_store.next_voice(context.call_source)
            end
            create evaluator.make(context.call_source)
            music := evaluator.eval(context.commit_context, context.args.last)
            if music /= Void then
               music_store.add_music(music)
            end
            Result := music_store.commit(context.commit_context)
         end
      end

   native_store_text (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      do
      end

   native_current_player (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      do
         create {MIXUP_STRING} Result.make(context.call_source, context.player.name, context.player.name)
      end

   native_map (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         sequence: MIXUP_VALUE
         mapper: MIXUP_AGENT
         executor: MIXUP_AGENT_EXECUTOR
      do
         if context.args.count /= 2 then
            error_at(context.call_source, "bad argument count")
         elseif not (mapper ?:= context.args.first) then
            error_at(context.args.first.source, "bad argument")
         else
            mapper ::= context.args.first
            sequence := context.args.last.eval(context.commit_context, True)
            create executor.map(context.call_source, sequence, mapper.expression.eval(context.commit_context, False))
            Result := executor.call(context.commit_context)
            check
               Result = Void
            end
         end
      end

   native_reduce (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         sequence, seed: MIXUP_VALUE
         mapper: MIXUP_AGENT
         executor: MIXUP_AGENT_EXECUTOR
      do
         if context.args.count /= 3 then
            error_at(context.call_source, "bad argument count")
         elseif not (mapper ?:= context.args.first) then
            error_at(context.args.first.source, "bad argument")
         else
            mapper ::= context.args.first
            seed := context.args.item(context.args.lower+1)
            sequence := context.args.last.eval(context.commit_context, True)
            create executor.reduce(context.call_source, sequence, mapper.expression.eval(context.commit_context, False), seed)
            Result := executor.call(context.commit_context)
         end
      end

   native_in_player (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT; name: STRING): MIXUP_VALUE
      require
         context.is_ready
      do
         Result := context.player.native(a_def_source, context, name)
      end

   native_staff_id (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         int: MIXUP_INTEGER
      do
         if context.args.count /= 1 then
            error_at(context.call_source, "bad argument count")
         elseif not (int ?:= context.args.first) then
            error_at(context.args.first.source, "expected an integer")
         else
            int ::= context.args.first
            create {MIXUP_VALUE_FACTORY} Result.make(context.call_source,
                                                     agent (a_int: INTEGER; a_src: MIXUP_SOURCE; a_cc: MIXUP_COMMIT_CONTEXT): MIXUP_STRING
                                                        local
                                                           str: STRING
                                                        do
                                                           if not a_cc.instrument.valid_relative_staff_id(a_int) then
                                                              fatal_at(a_src, "Invalid staff id: " + a_int.out)
                                                           end
                                                           str := a_cc.instrument.name + a_cc.instrument.absolute_staff_id(a_int).out
                                                           create Result.make(a_src, str.intern, ("%"" + str + "%"").intern)
                                                        end(int.value.to_integer_32, ?, ?))
         end
      end

   native_staff_index (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      do
         create {MIXUP_VALUE_FACTORY} Result.make(context.call_source,
                                                  agent (a_src: MIXUP_SOURCE; a_cc: MIXUP_COMMIT_CONTEXT): MIXUP_INTEGER
                                                     do
                                                        create Result.make(a_src, a_cc.instrument.relative_staff_id(a_cc.staff.id))
                                                     end)
      end

   native_skip_octave (a_def_source: MIXUP_SOURCE; context: MIXUP_NATIVE_CONTEXT): MIXUP_VALUE
      require
         context.is_ready
      local
         int: MIXUP_INTEGER
         skip: MIXUP_SKIP_OCTAVE
      do
         if context.args.count /= 1 then
            error_at(context.call_source, "bad argument count")
         elseif not (int ?:= context.args.first) then
            error_at(context.args.first.source, "expected an integer")
         else
            int ::= context.args.first
            create skip.make(context.call_source, int.value.to_integer_8)
            create {MIXUP_MUSIC_VALUE} Result.make(context.call_source, skip.commit(context.commit_context))
         end
      end

feature {ANY}
   item (a_source: like source; name: STRING): FUNCTION[TUPLE[MIXUP_NATIVE_CONTEXT], MIXUP_VALUE]
      do
         log.trace.put_line(once "Preparing native function: " | name)
         inspect
            name
         when "bar" then
            Result := agent native_bar(a_source, ?)
         when "with_lyrics" then
            Result := agent native_with_lyrics(a_source, ?)
         when "seq" then
            Result := agent native_seq(a_source, ?)
         when "map" then
            Result := agent native_map(a_source, ?)
         when "reduce" then
            Result := agent native_reduce(a_source, ?)
         when "new_music_store" then
            Result := agent native_new_music_store(a_source, ?)
         when "store_music" then
            Result := agent native_store_music(a_source, ?)
         when "store_text" then
            Result := agent native_store_text(a_source, ?)
         when "current_player" then
            Result := agent native_current_player(a_source, ?)
         when "staff_id" then
            Result := agent native_staff_id(a_source, ?)
         when "staff_index" then
            Result := agent native_staff_index(a_source, ?)
         when "skip_octave" then
            Result := agent native_skip_octave(a_source, ?)
         else
            Result := agent native_in_player(a_source, ?, name)
         end
      end

feature {}
   parser: MIXUP_PARSER
   players: COLLECTION[MIXUP_PLAYER]
   contexts: DICTIONARY[MIXUP_CONTEXT, FIXED_STRING]
   file_reader: FUNCTION[TUPLE[FIXED_STRING], TUPLE[MIXUP_NODE, FIXED_STRING]]

   make (a_file_reader: like file_reader)
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

end -- class MIXUP_MIXER
