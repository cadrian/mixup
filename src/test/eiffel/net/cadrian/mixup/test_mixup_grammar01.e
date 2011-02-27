class TEST_MIXUP_GRAMMAR01

insert
   EIFFELTEST_TOOLS
   MIXUP_NODE_HANDLER
   AUX_MIXUP_MOCK_PLAYER_EVENTS

create {}
   make

feature {}
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
                                        instrument singer
                                           music
                                              << :p,<:c4 d e f | g a b :f:c | :hidden:mp:c,1 >>
                                           lyrics
                                              << doe ray me far so la tea doe, doe. >>
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

         create mixer
         create player.make
         mixer.add_player(player)
         mixer.play(grammar.root_node)

         assert(player.events.is_equal({FAST_ARRAY[AUX_MIXUP_MOCK_EVENT] <<

                                        set_partitur("sample"),
                                        set_instrument("singer"),
                                        set_instrument("bass"),

                                        start_bar,
                                        set_dynamics("singer", "p", Void),
                                        set_dynamics("singer", "<", Void),
                                        set_note("singer", 1, 4, "c", 3, 4),
                                        set_lyric("singer", 1, 4, "doe"),
                                        set_note("bass", 1, 1, "c", 2, 1),
                                        set_note("singer", 2, 4, "d", 3, 4),
                                        set_lyric("singer", 2, 4, "ray"),
                                        set_note("singer", 3, 4, "e", 3, 4),
                                        set_lyric("singer", 3, 4, "me"),
                                        set_note("singer", 4, 4, "f", 3, 4),
                                        set_lyric("singer", 4, 4, "far"),
                                        end_bar,

                                        start_bar,
                                        set_note("singer", 1, 4, "g", 3, 4),
                                        set_lyric("singer", 1, 4, "so"),
                                        set_note("bass", 1, 1, "g", 1, 1),
                                        set_note("singer", 2, 4, "a", 4, 4),
                                        set_lyric("singer", 2, 4, "la"),
                                        set_note("singer", 3, 4, "b", 4, 4),
                                        set_lyric("singer", 3, 4, "tea"),
                                        set_dynamics("singer", "f", Void),
                                        set_note("singer", 4, 4, "c", 4, 4),
                                        set_lyric("singer", 4, 4, "doe,"),
                                        end_bar,

                                        start_bar,
                                        set_dynamics("singer", "mp", "hidden"),
                                        set_note("singer", 1, 1, "c", 3, 1),
                                        set_lyric("singer", 1, 1, "doe."),
                                        set_note("bass", 1, 1, "c", 2, 1),
                                        end_bar,

                                        end_piece
                                        >>}));
      end

end
