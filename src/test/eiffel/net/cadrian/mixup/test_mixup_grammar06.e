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
class TEST_MIXUP_GRAMMAR06

insert
   AUX_MIXUP_TESTS

create {}
   make

feature {}
   file_content (a_name: FIXED_STRING): STRING is
      do
         inspect
            a_name.out
         when "core" then
            Result := "[
                       module core

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

                       end

                       ]"
         end
      end

   make is
      local
         factory: AUX_MIXUP_GRAMMAR_NODE_FACTORY
         player: AUX_MIXUP_MOCK_PLAYER
         mixer: MIXUP_MIXER

         expected: COLLECTION[AUX_MIXUP_MOCK_EVENT]; i: INTEGER

         played_event, expected_event: AUX_MIXUP_MOCK_EVENT
      do
         create factory.make
         create grammar.with_factory(factory)

         create source.make
         create mixer.make(agent read_file)
         create player.make

         player.when_native("current_bar_number", agent current_bar_number_factory(player, ?))

         mixer.add_player(player)

         mixer.add_piece(parse("[
                                partitur sample

                                from core import repeat, repeat_inline, bar

                                set notes := music << c,4 >>

                                instrument singer
                                   music
                                      << \repeat(2, notes) | \repeat(2, notes) \bar("||") \repeat_inline(4, notes) >>
                                   end

                                end

                                ]"), "sample.mix")

         mixer.play

         expected := {FAST_ARRAY[AUX_MIXUP_MOCK_EVENT]
         <<

           set_partitur   ("sample"                                                          ),
           set_instrument ("singer", map(1, 1|..|5)                                          ),

           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 2 >>}                        ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 3 >>}                        ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 1 >>}                        ),
           set_note       ("singer", 1, {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           end_voices     ("singer", 1                                                       ),
           next_bar       ("singer", 1, ":||"                                                ),
           end_voices     ("singer", 1                                                       ),
           next_bar       ("singer", 1, Void                                                 ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 4 >>}                        ),
           next_bar       ("singer", 1, "||:"                                                ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 1 >>}                        ),
           set_note       ("singer", 1, {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           end_voices     ("singer", 1                                                       ),
           next_bar       ("singer", 1, ":||"                                                ),
           end_voices     ("singer", 1                                                       ),
           next_bar       ("singer", 1, "||"                                                 ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 5 >>}                        ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 1 >>}                        ),
           set_note       ("singer", 1, {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           end_voices     ("singer", 1                                                       ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 1 >>}                        ),
           set_note       ("singer", 1, {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           end_voices     ("singer", 1                                                       ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 1 >>}                        ),
           set_note       ("singer", 1, {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           end_voices     ("singer", 1                                                       ),
           start_voices   ("singer", 1, {FAST_ARRAY[INTEGER] << 1 >>}                        ),
           set_note       ("singer", 1, {MIXUP_CHORD duration_4, source, << note("c", 3) >> }),
           end_voices     ("singer", 1                                                       ),
           end_voices     ("singer", 1                                                       ),
           end_voices     ("singer", 1                                                       ),

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

end -- class TEST_MIXUP_GRAMMAR06
