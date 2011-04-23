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
class TEST_MIXUP_GRAMMAR04

insert
   AUX_MIXUP_TESTS

create {}
   make

feature {}
   file_content (a_name: FIXED_STRING): STRING is
      do
      end

   make is
      local
         factory: AUX_MIXUP_GRAMMAR_NODE_FACTORY
         parser_buffer: MINI_PARSER_BUFFER
         evaled: BOOLEAN
         player: AUX_MIXUP_MOCK_PLAYER
         mixer: MIXUP_MIXER_IMPL

         expected: COLLECTION[AUX_MIXUP_MOCK_EVENT]; i: INTEGER

         played_event, expected_event: AUX_MIXUP_MOCK_EVENT
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

                                        -- some music
                                        set gamme := music << { :p,<: c,4 d e f | g a b :f: c } >>

                                        -- the singer
                                        instrument singer
                                           music
                                              << \repeat(2, with_lyrics(gamme)) :hidden:mp: c,1 >>
                                           lyrics
                                              << doe ray me far sew la tea doe, _ >>
                                              << do re mi fa so la ti do, do. >>
                                           end

                                        -- small company
                                        instrument bass
                                           music
                                              << :p: c,,1 | g | { [ 3/2 c8 e g ] c'2. } >>
                                           end
                                        end

                                        ]")
         grammar.reset
         evaled := grammar.parse(parser_buffer)

         assert(evaled)
         assert(grammar.root_node /= Void)

         create mixer.make(agent read_file)
         create player.make
         mixer.add_player(player)
         mixer.add_piece(grammar.root_node, "test")

         player.when_native("current_bar_number", agent (a_context: MIXUP_CONTEXT; args: TRAVERSABLE[MIXUP_VALUE]): MIXUP_VALUE is
                                                     local
                                                        s: AUX_MIXUP_MOCK_SOURCE
                                                     do
                                                        create s.make
                                                        create {MIXUP_INTEGER} Result.make(s, 1)
                                                     end)

         mixer.play

         expected := {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]
         <<

           set_partitur   ("sample"                                                                                                     ),
           set_instrument ("singer"                                                                                                     ),
           set_instrument ("bass"                                                                                                       ),

           start_slur     ("singer", 1, 1, ""                                                                                           ),
           set_dynamics   ("singer", "p", Void                                                                                          ),
           set_dynamics   ("singer", "<", Void                                                                                          ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("c", 3) >> }, source, << "doe" , "do"  >> }), -- a deer, a female deer
           set_dynamics   ("bass",   "p", Void                                                                                          ),
           set_note       ("bass",                 {MIXUP_CHORD duration_1 , source, << note("c", 2) >> }                               ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("d", 3) >> }, source, << "ray" , "re"  >> }), -- a drop of golden sun
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("e", 3) >> }, source, << "me"  , "mi"  >> }), -- a name I call myself
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("f", 3) >> }, source, << "far" , "fa"  >> }), -- a long, long way to run

           next_bar       ("singer", Void                                                                                               ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("g", 3) >> }, source, << "sew" , "so"  >> }), -- a needle pulling thread
           next_bar       ("bass", Void                                                                                                 ),
           set_note       ("bass",                 {MIXUP_CHORD duration_1 , source, << note("g", 1) >> }                               ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("a", 4) >> }, source, << "la"  , "la"  >> }), -- a note to follow so
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("b", 4) >> }, source, << "tea" , "ti"  >> }), -- a drink with jam and bread
           set_dynamics   ("singer", "f", Void                                                                                          ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("c", 4) >> }, source, << "doe,", "do," >> }),
           end_slur       ("singer"                                                                                                     ),

           next_bar       ("singer", ":||"                                                                                              ),
           set_dynamics   ("singer", "mp", "hidden"                                                                                     ), -- that will bring us back to
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_1 , source, << note("c", 3) >> }, source, << "_"   , "do." >> }),
           next_bar       ("bass", Void                                                                                                 ),
           start_slur     ("bass", 1, 1, ""                                                                                             ),
           start_beam     ("bass", 3, 2, "3"                                                                                            ),
           set_note       ("bass",                 {MIXUP_CHORD duration_8 , source, << note("c", 2) >> }                               ),
           set_note       ("bass",                 {MIXUP_CHORD duration_8 , source, << note("e", 2) >> }                               ),
           set_note       ("bass",                 {MIXUP_CHORD duration_8 , source, << note("g", 2) >> }                               ),
           end_beam       ("bass",                                                                                                      ),
           set_note       ("bass",                 {MIXUP_CHORD duration_2p, source, << note("c", 3) >> }                               ),
           end_slur       ("bass",                                                                                                      ),

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

end -- class TEST_MIXUP_GRAMMAR04
