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
class TEST_MIXUP_GRAMMAR05

insert
   EIFFELTEST_TOOLS
   MIXUP_NODE_HANDLER
   MIXUP_NOTE_DURATIONS
   AUX_MIXUP_MOCK_PLAYER_EVENTS
   LOGGING

create {}
   make

feature {}
   note (a_note: STRING; a_octave: INTEGER): MIXUP_NOTE_HEAD is
      do
         Result.set(a_note, a_octave)
      end

   make is
      local
         grammar: MIXUP_GRAMMAR
         factory: AUX_MIXUP_GRAMMAR_NODE_FACTORY
         parser_buffer: MINI_PARSER_BUFFER
         evaled: BOOLEAN
         player: AUX_MIXUP_MOCK_PLAYER
         mixer: MIXUP_MIXER_IMPL

         expected: COLLECTION[AUX_MIXUP_MOCK_EVENT]; i: INTEGER

         played_event, expected_event: AUX_MIXUP_MOCK_EVENT
         source: AUX_MIXUP_MOCK_SOURCE
      do
         create source.make
         create factory.make
         create grammar.with_factory(factory)
         create parser_buffer

         parser_buffer.initialize_with("[
                                        partitur sample

                                        -- all those functions will surely be defined in a core module:
                                        set bar := function(style) native "bar"
                                        set seq := function(lower, upper) native "seq"
                                        set new_music_store := function native "new_music_store"
                                        set store_music := function(memory, mus) native "store_music"
                                        set store_text := function(memory, str, pos) native "store_text"
                                        set with_lyrics := function(mus) native "with_lyrics"
                                        set current_bar_number := function native "current_bar_number"

                                        set repeat_inline := function(volte, mus) do
                                                                Result := new_music_store
                                                                for i in seq(1, volte) do
                                                                   store_music(Result, mus)
                                                                end
                                                             end

                                        set repeat := function(volte, mus) do
                                                         Result := new_music_store
                                                         if current_bar_number > 1 then
                                                            store_music(Result, bar("||:"))
                                                         end
                                                         if volte > 2 then
                                                            store_text(Result, volte + " times", "up")
                                                         end
                                                         store_music(Result, mus)
                                                         store_music(Result, bar(":||"))
                                                      end

                                        set notes := music << c,4 >>

                                        instrument singer
                                           music
                                              << \repeat(2, notes) | \repeat(2, notes) \bar("||") \repeat_inline(4, notes) >>
                                           end

                                        end

                                        ]")
         grammar.reset
         evaled := grammar.parse(parser_buffer)

         assert(evaled)
         assert(grammar.root_node /= Void)

         create mixer.make
         create player.make
         mixer.add_player(player)
         mixer.add_piece(grammar.root_node, "test")

         player.when_native("current_bar_number", agent (a_player: AUX_MIXUP_MOCK_PLAYER; a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
                                                     local
                                                        s: AUX_MIXUP_MOCK_SOURCE
                                                     do
                                                        create s.make
                                                        create {MIXUP_INTEGER} Result.make(s, a_context.bar_number)
                                                     end (player, ?, ?))

         mixer.play

         expected := {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]
         <<

           set_partitur   ("sample"                                                       ),
           set_instrument ("singer"                                                       ),

           set_note       ("singer", {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           next_bar       ("singer", ":||"                                                ),
           next_bar       ("singer", Void                                                 ),
           next_bar       ("singer", "||:"                                                ),
           set_note       ("singer", {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           next_bar       ("singer", ":||"                                                ),
           next_bar       ("singer", "||"                                                 ),
           set_note       ("singer", {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           set_note       ("singer", {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           set_note       ("singer", {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           set_note       ("singer", {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),

           end_partitur

           >>}

         log.info.put_line(once "----------------------------------------------------------------------")
         log.info.put_line(once "Found events:")
         player.events.do_all(agent (event: AUX_MIXUP_MOCK_EVENT) is do log.info.put_line(event.out) end)
         log.info.put_line(once "----------------------------------------------------------------------")

         assert(player.events.count.is_equal(expected.count))
         from
            i := expected.lower
         until
            i > expected.upper
         loop
            expected_event := expected.item(i)
            played_event := player.events.item(i + player.events.lower - expected.lower)
            log.info.put_line(i.out + "%T" + played_event.out + "%N vs.%T" + expected_event.out)
            assert(played_event.is_equal(expected_event))
            i := i + 1
         end
      end

end -- class TEST_MIXUP_GRAMMAR05