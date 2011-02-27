class TEST_MIXUP_GRAMMAR01

insert
   EIFFELTEST_TOOLS

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
      do
         create factory.make
         create grammar.with_factory(factory)
         create parser.make
         create parser_buffer

         parser_buffer.initialize_with("[
                                        partitur sample
                                        from mixup.core import *
                                        set time = common_time
                                        instrument piano
                                           set staves = 2
                                           set staff(1).clef = bass
                                           set staff(2).clef = trebble
                                           music
                                              << :p,<:c4 d e f | g a b :f:c | :hidden:mp:c,1 >>
                                           end
                                        end
                                        ]")
         grammar.reset
         evaled := parser.eval(parser_buffer, grammar.table, once "File")

         assert(evaled)
      end

end
