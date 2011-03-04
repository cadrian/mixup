class TEST_MIXUP_GRAMMAR01

insert
   EIFFELTEST_TOOLS
   MIXUP_NODE_HANDLER
   MIXUP_NOTE_DURATIONS
   AUX_MIXUP_MOCK_PLAYER_EVENTS

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
         mixer: MIXUP_MIXER
      do
         create factory.make
         create grammar.with_factory(factory)
         create parser.make
         create parser_buffer

         parser_buffer.initialize_with("[
                                        partitur sample
                                        set hook.at_end := function native "emit"
                                        instrument singer
                                           music
                                              << :p,<: c4 d e f | g a b :f:c | :hidden:mp: c,1 >>
                                           lyrics
                                              << doe ray me far sew la tea doe, doe. >>
                                              << do re mi fa so la ti do, do. >>
                                           end
                                        instrument bass
                                           music
                                              << :p: c,1 | g, | c' >>
                                           end
                                        end
                                        ]")
         grammar.reset
         evaled := parser.eval(parser_buffer, grammar.table, once "File")

         assert(evaled)
         assert(grammar.root_node /= Void)

         grammar.root_node.generate(std_output)
         std_output.put_new_line

         create mixer.make
         create player.make
         mixer.add_player(player)
         mixer.add_piece(grammar.root_node)
         mixer.play

         std_output.put_line("Events: " + player.events.out)
         assert(player.events.is_equal({FAST_ARRAY[AUX_MIXUP_MOCK_EVENT] <<

                                        set_partitur("sample"),
                                        set_instrument("singer"),
                                        set_instrument("bass"),

                                        start_bar,
                                        set_dynamics("singer", "p", Void),
                                        set_dynamics("singer", "<", Void),
                                        set_note("singer",    0, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("c", 3) >> }, << "doe" , "do"  >> }), -- a deer, a female deer
                                        set_note("bass",      0,               {MIXUP_CHORD duration_1, << note("c", 2) >> }),
                                        set_note("singer",   64, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("d", 3) >> }, << "ray" , "re"  >> }), -- a drop of golden sun
                                        set_note("singer",  128, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("e", 3) >> }, << "me"  , "mi"  >> }), -- a name I call myself
                                        set_note("singer",  192, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("f", 3) >> }, << "far" , "fa"  >> }), -- a long, long way to run
                                        end_bar,

                                        start_bar,
                                        set_note("singer",  256, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("g", 3) >> }, << "sew" , "so"  >> }), -- a needle pulling thread
                                        set_note("bass",    256,               {MIXUP_CHORD duration_1, << note("g", 1) >> }),
                                        set_note("singer",  320, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("a", 4) >> }, << "la"  , "la"  >> }), -- a note to follow so
                                        set_note("singer",  384, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("b", 4) >> }, << "tea" , "ti"  >> }), -- a drink with jam and bread
                                        set_dynamics("singe   r", "f", Void),
                                        set_note("singer",  448, {MIXUP_LYRICS {MIXUP_CHORD duration_4, << note("c", 4) >> }, << "doe,", "do," >> }),
                                        end_bar,

                                        start_bar,
                                        set_dynamics("singer", "mp", "hidden"),                                                                                     -- that will bring us back to
                                        set_note("singer",  512, {MIXUP_LYRICS {MIXUP_CHORD duration_1, << note("c", 3) >> }, << "doe.", "do." >> }),
                                        set_note("bass",    512,               {MIXUP_CHORD duration_1, << note("c", 2) >> }),
                                        end_bar,

                                        end_partitur
                                        >>}));
      end

end
