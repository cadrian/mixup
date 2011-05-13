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
class TEST_MIXUP_GRAMMAR01

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
         parser: DESCENDING_PARSER
         parser_buffer: MINI_PARSER_BUFFER
         evaled: BOOLEAN
         player: AUX_MIXUP_MOCK_PLAYER
         mixer: MIXUP_MIXER

         expected: COLLECTION[AUX_MIXUP_MOCK_EVENT]; i: INTEGER

         played_event, expected_event: AUX_MIXUP_MOCK_EVENT
      do
         create source.make
         create factory.make
         create grammar.with_factory(factory)
         create parser.make
         create parser_buffer

         parser_buffer.initialize_with("[
                                        partitur sample
                                        set with_lyrics := function(mus) native "with_lyrics" -- forces lyrics even if in a slur
                                        instrument singer
                                           music
                                              << :p,<: \with_lyrics(music << (c,4 d e f | g a b :f: c) >>) | :hidden:mp: c,1 >>
                                           lyrics
                                              << doe ray me far sew la tea doe, doe. >>
                                              << do re mi fa so la ti do, do. >>
                                           end
                                        instrument bass
                                           music
                                              << :p: c,,1 | g | {[3/2 c8 e g] c'2.} >>
                                           end
                                        end
                                        ]")
         grammar.reset
         evaled := parser.eval(parser_buffer, grammar.table, once "File")

         assert(evaled)
         assert(grammar.root_node /= Void)

         create mixer.make(agent read_file)
         create player.make
         mixer.add_player(player)
         mixer.add_piece(grammar.root_node, "test")
         mixer.play

         expected := {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]
         <<

           set_partitur       ("sample"                                                                                                        ),
           set_instrument     ("singer", map(1, 1|..|3)                                                                                        ),
           set_instrument     ("bass"  , map(2, 4|..|6)                                                                                        ),

           set_dynamics       ("singer", 1, "p", Void                                                                                          ),
           set_dynamics       ("singer", 1, "<", Void                                                                                          ),
           start_slur         ("singer", 1, 1, 1, ""                                                                                           ),
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("c", 3) >> }, source, << "doe" , "do"  >> }), -- a deer, a female deer
           set_dynamics       ("bass",   2, "p", Void                                                                                          ),
           set_note           ("bass",   2,               {MIXUP_CHORD duration_1 , source, << note("c", 2) >> }                               ),
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("d", 3) >> }, source, << "ray" , "re"  >> }), -- a drop of golden sun
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("e", 3) >> }, source, << "me"  , "mi"  >> }), -- a name I call myself
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("f", 3) >> }, source, << "far" , "fa"  >> }), -- a long, long way to run

           next_bar           ("singer", 1, Void                                                                                               ),
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("g", 3) >> }, source, << "sew" , "so"  >> }), -- a needle pulling thread
           next_bar           ("bass",   2, Void                                                                                               ),
           set_note           ("bass",   2,               {MIXUP_CHORD duration_1 , source, << note("g", 1) >> }                               ),
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("a", 4) >> }, source, << "la"  , "la"  >> }), -- a note to follow so
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("b", 4) >> }, source, << "tea" , "ti"  >> }), -- a drink with jam and bread
           set_dynamics       ("singer", 1, "f", Void                                                                                         ),
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_4 , source, << note("c", 4) >> }, source, << "doe,", "do," >> }),
           end_slur           ("singer", 1                                                                                                     ),

           next_bar           ("singer", 1, Void                                                                                               ),
           set_dynamics       ("singer", 1, "mp", "hidden"                                                                                     ), -- that will bring us back to
           set_note           ("singer", 1, {MIXUP_LYRICS {MIXUP_CHORD duration_1 , source, << note("c", 3) >> }, source, << "doe.", "do." >> }),
           next_bar           ("bass",   2, Void                                                                                               ),
           start_phrasing_slur("bass",   2, 1, 1, ""                                                                                           ),
           start_beam         ("bass",   2, 3, 2, "3"                                                                                          ),
           set_note           ("bass",   2,               {MIXUP_CHORD duration_8 , source, << note("c", 2) >> }                               ),
           set_note           ("bass",   2,               {MIXUP_CHORD duration_8 , source, << note("e", 2) >> }                               ),
           set_note           ("bass",   2,               {MIXUP_CHORD duration_8 , source, << note("g", 2) >> }                               ),
           end_beam           ("bass",   2,                                                                                                    ),
           set_note           ("bass",   2,               {MIXUP_CHORD duration_2p, source, << note("c", 3) >> }                               ),
           end_phrasing_slur  ("bass",   2,                                                                                                    ),

           end_partitur

           >>}

         --assert(player.events.count.is_equal(expected.count))
         from
            i := expected.lower
         until
            i > expected.upper or else i + player.events.lower - expected.lower > player.events.upper
         loop
            expected_event := expected.item(i)
            played_event := player.events.item(i + player.events.lower - expected.lower)
            log.info.put_line(i.out + "%T" + played_event.out + "%N vs.%T" + expected_event.out)
            assert(played_event.is_equal(expected_event))
            i := i + 1
         end
      end

end -- class TEST_MIXUP_GRAMMAR01
