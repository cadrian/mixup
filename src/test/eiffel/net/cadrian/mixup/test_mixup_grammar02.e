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

end -- class TEST_MIXUP_GRAMMAR02
