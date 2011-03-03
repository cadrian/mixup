class MIXUP_MIXER

inherit
   MIXUP_LIST_NODE_IMPL_VISITOR
   MIXUP_NON_TERMINAL_NODE_IMPL_VISITOR
   MIXUP_TERMINAL_NODE_IMPL_VISITOR

create {ANY}
   make

feature {ANY}
   play (a_piece: MIXUP_NODE) is
      require
         a_piece /= Void
      do
         a_piece.accept(Current)
      end

   add_player (a_player: MIXUP_PLAYER) is
      require
         a_player /= Void
      do
         players.add_last(a_player)
      end

feature {MIXUP_LIST_NODE_IMPL}
   visit_mixup_list_node_impl (node: MIXUP_LIST_NODE_IMPL) is
      do
         inspect
            node.name
         when "Value*" then
            build_value_list(node)
         when "Voice+" then
            build_voices(node)
         else
            node.accept_all(Current)
         end
      end

feature {MIXUP_NON_TERMINAL_NODE_IMPL}
   visit_mixup_non_terminal_node_impl (node: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         inspect
            node.name
         when "File", "File_Content" then
            node.node_at(0).accept(Current)
         when "Score" then
            play_score(node)
         when "Book" then
            play_book(node)
         when "Partitur" then
            play_partitur(node)
         when "Partitur_Content" then
            play_partitur_content(node)
         when "Score_Content", "Book_Content", "Some_Music", "Notes", "Voices", "Voice", "Some_Lyrics", "Word", "Strophe"
          then
            node.accept_all(Current)
         when "Music", "Lyrics" then
            node.node_at(1).accept(Current)
         when "Instrument" then
            play_instrument(node)
         when "Next_Bar" then
            play_next_bar(node)
         when "Up_Staff" then
            play_up_staff(node)
         when "Down_Staff" then
            play_down_staff(node)
         when "Extern_Notes", "Extern_Syllable" then
            not_yet_implemented
         when "Dynamics" then
            play_dynamics(node)
         when "Chord" then
            play_chord(node)
         when "Note_Head" then
            build_note_head(node)
         when "Note_Length" then
            build_note_length(node)
         when "Dot" then
            last_note_length := last_note_length + last_note_length // 2
         when "DotDot" then
            last_note_length := last_note_length + last_note_length // 2 + last_note_length // 4
         when "Beam" then
            play_beam(node)
         when "Slur" then
            play_slur(node)
         when "Tie" then
            play_tie(node)
         when "Syllable" then
            play_syllable(node)
         when "Identifier" then
            build_identifier(node)
         when "Identifier_Part" then
            build_identifier_part(node)
         when "Identifier_Args" then
            build_identifier_args(node)
         when "Value" then
            build_value(node)
         end
      end

feature {MIXUP_TERMINAL_NODE_IMPL}
   visit_mixup_terminal_node_impl (node: MIXUP_TERMINAL_NODE_IMPL) is
      local
         string_image: TYPED_MIXUP_IMAGE[STRING]
         integer_image: TYPED_MIXUP_IMAGE[INTEGER_64]
         real_image: TYPED_MIXUP_IMAGE[REAL]
         boolean_image: TYPED_MIXUP_IMAGE[BOOLEAN]
      do
         inspect
            node.name
         when "KW identifier" then
            name := node.image.image.intern
         when "KW string" then
            string_image ::= node.image
            create {MIXUP_STRING} last_value.make(string_image.decoded)
         when "KW number" then
            if integer_image ?:= node.image then
               integer_image ::= node.image
               create {MIXUP_INTEGER} last_value.make(integer_image.decoded)
            elseif real_image ?:= node.image then
               real_image ::= node.image
               create {MIXUP_REAL} last_value.make(real_image.decoded)
            else
               not_yet_implemented -- error: invalid number
            end
         when "KW boolean" then
            boolean_image ::= node.image
            create {MIXUP_BOOLEAN} last_value.make(boolean_image.decoded)
         when "KW note head" then
            last_note_head := node.image.image
         else
            -- skipped
         end
      end

feature {}
   name: FIXED_STRING
   identifier: MIXUP_IDENTIFIER
   last_value: MIXUP_VALUE
   last_values: COLLECTION[MIXUP_VALUE]
   last_note_length: INTEGER_64
   last_note_head: STRING
   note_heads: COLLECTION[STRING]
   last_compound_music: MIXUP_COMPOUND_MUSIC
   instruments: COLLECTION[MIXUP_INSTRUMENT]

   build_identifier (dot_identifier: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         if dot_identifier.count = 1 then
            create identifier.make
            dot_identifier.node_at(0).accept(Current)
         else
            dot_identifier.node_at(3).accept(Current)
            dot_identifier.node_at(0).accept(Current)
         end
      end

   build_identifier_part (identifier_part: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         identifier_part.node_at(0).accept(Current)
         identifier.with_prefix(name)
         identifier_part.node_at(2).accept(Current)
      end

   build_identifier_args (identifier_args: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         identifier_args.node_at(1).accept(Current)
         identifier.set_args(last_values)
      end

   build_value (value: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_value := Void
         value.accept_all(Current)
         check
            last_value /= Void
         end
      end

   build_value_list (value_list: MIXUP_LIST_NODE_IMPL) is
      local
         i: INTEGER
      do
         create {FAST_ARRAY[MIXUP_VALUE]} last_values.with_capacity((value_list.count + 1) // 2)
         from
            i := value_list.lower
         until
            i > value_list.upper
         loop
            value_list.item(i).accept(Current)
            last_values.add_last(last_value)
            i := i + 2
         end
      end

   build_voices (a_voices: MIXUP_LIST_NODE_IMPL) is
      local
         i: INTEGER; old_compound_music: like last_compound_music
         voices: MIXUP_VOICES
      do
         old_compound_music := last_compound_music
         if old_compound_music = Void then
            create voices.make(absolute_reference)
         else
            create voices.make(old_compound_music.reference)
         end
         last_compound_music := voices

         from
            i := a_voices.lower
         until
            i > a_voices.upper
         loop
            voices.next_voice
            a_voices.item(i).accept(Current)
            i := i + 1
         end

         voices.commit
         if old_compound_music /= Void then
            old_compound_music.add_music(voices)
            last_compound_music := old_compound_music
         end
      end

   absolute_reference: MIXUP_NOTE_HEAD is
      once
         Result.set("a", 4)
      end

feature {}
   play_score (score: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         score.node_at(1).accept(Current)
         fire_set_score(name)
         score.node_at(2).accept(Current)
         fire_end_score
      end

   play_book (book: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         book.node_at(1).accept(Current)
         fire_set_book(name)
         book.node_at(2).accept(Current)
         fire_end_book
      end

   play_partitur (partitur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         partitur.node_at(1).accept(Current)
         fire_set_partitur(name)
         partitur.node_at(2).accept(Current)
         fire_end_partitur
      end

   add_all_bars (instrument: MIXUP_INSTRUMENT; barset: SET[INTEGER_64]) is
      do
         instrument.voices.bars.do_all(agent (bar: INTEGER_64; barset: SET[INTEGER_64]) is do barset.add(bar) end (?, barset))
      end

   play_partitur_content (partitur_content: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         time: INTEGER_64
         bars: ITERATOR[INTEGER_64]
         barset: SET[INTEGER_64]
         notes: MIXUP_NOTES_ITERATOR_ON_INSTRUMENTS
      do
         create {FAST_ARRAY[MIXUP_INSTRUMENT]} instruments.make(0)
         partitur_content.accept_all(Current)
         create {HASHED_SET[INTEGER_64]} barset.make
         instruments.do_all(agent add_all_bars(?, barset))
         bars := barset.new_iterator

         from
            create notes.make(instruments)
            fire_start_bar
         until
            notes.is_off
         loop
            if not bars.is_off and then bars.item <= notes.item.time then
               fire_end_bar
               fire_start_bar
               bars.next
            end
            fire_set_note(notes.item.instrument,
                          time,
                          notes.item.note)
            time := time + notes.item.time
            notes.next
         end
         fire_end_bar
      end

   play_instrument (instrument: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         voices: MIXUP_VOICES
      do
         instrument.node_at(1).accept(Current)
         create current_instrument.make(name, absolute_reference)
         instruments.add_last(current_instrument)
         fire_set_instrument(name)
         last_compound_music := Void
         instrument.node_at(2).accept(Current)
         instrument.node_at(3).accept(Current)
         voices ::= last_compound_music
         current_instrument.set_voices(voices)
         current_instrument.commit_lyrics
      end

   play_next_bar (next_bar: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_compound_music.next_bar
      end

   play_up_staff (up_staff: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_compound_music.up_staff
      end

   play_down_staff (down_staff: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_compound_music.down_staff
      end

   play_dynamics (dynamics: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         -- TODO
      end

   play_group (group: MIXUP_NON_TERMINAL_NODE_IMPL; grouped_music: MIXUP_GROUPED_MUSIC) is
      local
         old_compound_music: like last_compound_music
      do
         old_compound_music := last_compound_music
         last_compound_music := grouped_music
         group.node_at(1).accept(Current)
         old_compound_music.add_music(grouped_music)
         last_compound_music := old_compound_music
      end

   play_beam (beam: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         play_group(beam, create {MIXUP_GROUPED_MUSIC}.as_beam(last_compound_music.reference))
      end

   play_slur (slur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         play_group(slur, create {MIXUP_GROUPED_MUSIC}.as_slur(last_compound_music.reference))
      end

   play_tie (tie: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         play_group(tie, create {MIXUP_GROUPED_MUSIC}.as_tie(last_compound_music.reference))
      end

   play_chord (chord: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create {FAST_ARRAY[STRING]} note_heads.make(0)
         if chord.count = 2 then
            chord.node_at(0).accept(Current)
            chord.node_at(1).accept(Current)
         else
            chord.node_at(1).accept(Current)
            chord.node_at(3).accept(Current)
         end
         last_compound_music.add_chord(note_heads, last_note_length)
      end

   build_note_head (note_head: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         note_head.node_at(0).accept(Current)
         note_heads.add_last(last_note_head)
      end

   build_note_length (note_length: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         number: MIXUP_INTEGER
      do
         if note_length.count = 0 then
            -- OK, keep previous
         else
            note_length.node_at(0).accept(Current)
            if number ?:= last_value then
               number ::= last_value
               if number.value.fit_integer_32 then
                  last_note_length := number.value
                  inspect
                     last_note_length
                  when 1, 2, 4, 8, 16, 32, 64 then
                     last_note_length := {INTEGER_64 256} // last_note_length -- make it divisible by 4 (because of dots), and restore a correct order in lengths
                  else
                     not_yet_implemented -- error: invalid note length
                  end
               else
                  not_yet_implemented -- error: invalid note length
               end
            else
               not_yet_implemented -- error: invalid note length
            end
         end
      end

feature {} -- Building music
   current_instrument: MIXUP_INSTRUMENT

   play_notes (notes: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         notes.accept_all(Current)
      end

   play_syllable (syllable: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         syllable.accept_all(Current)
      end

feature {} -- Player events
   fire_set_book (book_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_book(book_name))
      end

   fire_end_book is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_book);
      end

   fire_set_score (score_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_score(score_name))
      end

   fire_end_score is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_score);
      end

   fire_set_partitur (partitur_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_partitur(partitur_name))
      end

   fire_end_partitur is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_partitur);
      end

   fire_set_instrument (instrument_name: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_instrument(instrument_name))
      end

   fire_set_dynamics (instrument_name, dynamics, position: ABSTRACT_STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_dynamics(instrument_name, dynamics, position))
      end

   fire_set_note (instrument_name: ABSTRACT_STRING; time_start: INTEGER_64; note: MIXUP_NOTE) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_note(instrument_name, time_start, note));
      end

   fire_start_bar is
      do
         players.do_all(agent {MIXUP_PLAYER}.start_bar);
      end

   fire_end_bar is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_bar);
      end

feature {}
   players: COLLECTION[MIXUP_PLAYER]

   make is
      do
         create {FAST_ARRAY[MIXUP_PLAYER]} players.make(0)
      end

end
