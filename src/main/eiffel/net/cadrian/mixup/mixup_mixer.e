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
         node.accept_all(Current)
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
         when "Score_Content", "Book_Content", "Partitur_Content" then
            node.accept_all(Current)
         when "Instrument" then
            play_instrument(node)
         end
      end

feature {MIXUP_TERMINAL_NODE_IMPL}
   visit_mixup_terminal_node_impl (node: MIXUP_TERMINAL_NODE_IMPL) is
      do
         inspect
            node.name
         when "KW identifier" then
            identifier := node.image.image
         end
      end

feature {}
   identifier: STRING

   play_score (score: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         score.node_at(1).accept(Current)
         fire_set_score(identifier)
         score.node_at(2).accept(Current)
         fire_end_score
      end

   play_book (book: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         book.node_at(1).accept(Current)
         fire_set_book(identifier)
         book.node_at(2).accept(Current)
         fire_end_book
      end

   play_partitur (partitur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         partitur.node_at(1).accept(Current)
         fire_set_partitur(identifier)
         partitur.node_at(2).accept(Current)
         fire_end_partitur
      end

   play_instrument (instrument: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         instrument.node_at(1).accept(Current)
         fire_set_instrument(identifier)
         instrument.node_at(2).accept(Current)
         music.add(instrument.node_at(3), identifier.intern)
      end

feature {} -- Player events
   fire_set_book (book_name: STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_book(book_name))
      end

   fire_end_book is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_book);
      end

   fire_set_score (score_name: STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_score(score_name))
      end

   fire_end_score is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_score);
      end

   fire_set_partitur (partitur_name: STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_partitur(partitur_name))
      end

   fire_end_partitur is
      do
         players.do_all(agent {MIXUP_PLAYER}.end_partitur);
      end

   fire_set_instrument (instrument_name: STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_instrument(instrument_name))
      end

   fire_set_dynamics (instrument_name, dynamics, position: STRING) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_dynamics(instrument_name, dynamics, position))
      end

   fire_set_note (instrument_name: STRING; time_start, time_tactus: INTEGER; note: MIXUP_NOTE) is
      do
         players.do_all(agent {MIXUP_PLAYER}.set_note(instrument_name, time_start, time_tactus, note));
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
   music: DICTIONARY[MIXUP_NODE, FIXED_STRING]

   make is
      do
         create {FAST_ARRAY[MIXUP_PLAYER]} players.make(0)
         create {HASHED_DICTIONARY[MIXUP_NODE, FIXED_STRING]} music.make
      end

end
