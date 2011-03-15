class TEST_MIXUP_GRAMMAR03

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
         parser: DESCENDING_PARSER
         parser_buffer: MINI_PARSER_BUFFER
         evaled: BOOLEAN
         player: AUX_MIXUP_MOCK_PLAYER
         mixer: MIXUP_MIXER_IMPL

         expected: COLLECTION[AUX_MIXUP_MOCK_EVENT]; i: INTEGER

         played_event, expected_event: AUX_MIXUP_MOCK_EVENT
      do
         create factory.make
         create grammar.with_factory(factory)
         create parser.make
         create parser_buffer

         parser_buffer.initialize_with("[
                                        partitur sample
                                        -- all those functions will surely be defined in a core module:
                                        set hook.at_end := function native "play"
                                        set repeat := function(volte, mus) native "repeat"
                                        set gamme := music << { :p,<: c,4 d e f | g a b :f: c } >>
                                        -- the singer
                                        instrument singer
                                           music
                                              << \repeat(2, gamme) | :hidden:mp: c,1 >>
                                           lyrics
                                              << doe ray me far sew la tea doe, _ >>
                                              << do re mi fa so la ti do, do. >>
                                           end
                                        -- small compagny
                                        instrument bass
                                           music
                                              << :p: c,,1 | g | { [ 3/2 c8 e g ] c'2. } >>
                                           end
                                        end
                                        ]")
         grammar.reset
         evaled := parser.eval(parser_buffer, grammar.table, once "File")

         assert(evaled)
         assert(grammar.root_node /= Void)

         create mixer.make
         create player.make
         mixer.add_player(player)
         mixer.add_piece(grammar.root_node)
         mixer.play

         expected := {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]
         <<

           set_partitur   ("sample"                                                                                     ),
           set_instrument ("singer"                                                                                     ),
           set_instrument ("bass"                                                                                       ),

           start_repeat   ("singer", 2                                                                                  ),
           start_slur     ("singer", 1, 1, ""                                                                           ),
           set_dynamics   ("singer", "p", Void                                                                          ),
           set_dynamics   ("singer", "<", Void                                                                          ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("c", 3) >> }, << "doe" , "do"  >> }), -- a deer, a female deer
           set_dynamics   ("bass",   "p", Void                                                                          ),
           set_note       ("bass",                 {MIXUP_CHORD duration_1 , << note("c", 2) >> }                       ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("d", 3) >> }, << "ray" , "re"  >> }), -- a drop of golden sun
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("e", 3) >> }, << "me"  , "mi"  >> }), -- a name I call myself
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("f", 3) >> }, << "far" , "fa"  >> }), -- a long, long way to run

           next_bar       ("singer"                                                                                     ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("g", 3) >> }, << "sew" , "so"  >> }), -- a needle pulling thread
           next_bar       ("bass"                                                                                       ),
           set_note       ("bass",                 {MIXUP_CHORD duration_1 , << note("g", 1) >> }                       ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("a", 4) >> }, << "la"  , "la"  >> }), -- a note to follow so
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("b", 4) >> }, << "tea" , "ti"  >> }), -- a drink with jam and bread
           set_dynamics   ("singer", "f", Void                                                                         ),
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_4 , << note("c", 4) >> }, << "doe,", "do," >> }),
           end_slur       ("singer"                                                                                     ),
           end_repeat     ("singer"                                                                                     ),

           next_bar       ("singer"                                                                                     ),
           set_dynamics   ("singer", "mp", "hidden"                                                                     ), -- that will bring us back to
           set_note       ("singer", {MIXUP_LYRICS {MIXUP_CHORD duration_1 , << note("c", 3) >> }, << "_", "do." >> }),
           next_bar       ("bass"                                                                                       ),
           start_slur     ("bass", 1, 1, ""                                                                             ),
           start_beam     ("bass", 3, 2, "3"                                                                            ),
           set_note       ("bass",                 {MIXUP_CHORD duration_8 , << note("c", 2) >> }                       ),
           set_note       ("bass",                 {MIXUP_CHORD duration_8 , << note("e", 2) >> }                       ),
           set_note       ("bass",                 {MIXUP_CHORD duration_8 , << note("g", 2) >> }                       ),
           end_beam       ("bass",                                                                                      ),
           set_note       ("bass",                 {MIXUP_CHORD duration_2p, << note("c", 3) >> }                       ),
           end_slur       ("bass",                                                                                      ),

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

end
