class TEST_MIXUP_GRAMMAR02

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
                                        module test
                                        set x := 4
                                        set something := function(x) native "external_fun"
                                        export foobar := function do something(x) end
                                        end
                                        ]")
         grammar.reset
         evaled := parser.eval(parser_buffer, grammar.table, once "File")

         assert(evaled)
         assert(parser_buffer.last_error = Void)
      end

end
