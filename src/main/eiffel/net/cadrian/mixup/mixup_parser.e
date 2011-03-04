class MIXUP_PARSER

inherit
   MIXUP_LIST_NODE_IMPL_VISITOR
   MIXUP_NON_TERMINAL_NODE_IMPL_VISITOR
   MIXUP_TERMINAL_NODE_IMPL_VISITOR

create {ANY}
   make

feature {ANY}
   parse (a_piece: MIXUP_NODE): MIXUP_CONTEXT is
      require
         a_piece /= Void
      do
         a_piece.accept(Current)
         Result := root_context
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
         when "Identifier" then
            build_identifier(node)
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
         when "Set" then
            build_definition(node, False)
         when "Export" then
            build_definition(node, True)
         when "Score" then
            play_score(node)
         when "Book" then
            play_book(node)
         when "Partitur" then
            play_partitur(node)
         when "Partitur_Content" then
            play_partitur_content(node)
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
         when "Identifier_Part" then
            build_identifier_part(node)
         when "Identifier_Args" then
            build_identifier_args(node)
         when "Value" then
            build_value(node)
         when "Function_Native" then
            build_function_native(node)
         when "Function_User" then
            build_function_user(node)
         else
            node.accept_all(Current)
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
            create {MIXUP_STRING} last_value.make(string_image.decoded, string_image.image)
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
   root_context: MIXUP_CONTEXT
   name: FIXED_STRING
   identifier: MIXUP_IDENTIFIER
   last_value: MIXUP_VALUE
   last_values: COLLECTION[MIXUP_VALUE]
   last_note_length: INTEGER_64
   last_note_head: STRING
   note_heads: COLLECTION[STRING]
   last_compound_music: MIXUP_COMPOUND_MUSIC
   current_context: MIXUP_CONTEXT

   build_identifier (dot_identifier: MIXUP_LIST_NODE_IMPL) is
      do
         create identifier.make
         dot_identifier.accept_all(Current)
      end

   build_identifier_part (identifier_part: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         identifier_part.node_at(0).accept(Current)
         identifier.add_identifier_part(name)
         identifier_part.node_at(1).accept(Current)
      end

   build_identifier_args (identifier_args: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         if not identifier_args.is_empty then
            identifier_args.node_at(1).accept(Current)
            identifier.set_args(last_values)
         end
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

feature {} -- Functions
   last_function: MIXUP_FUNCTION

   build_function_native (function_native: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         string: MIXUP_STRING
      do
         function_native.node_at(1).accept(Current)
         string ::= last_value
         create {MIXUP_NATIVE_FUNCTION} last_function.make(string.value)
         last_value := last_function
      end

   build_function_user (function_user: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         -- TODO
         -- last_value := last_function
      end

   build_definition (definition: MIXUP_NON_TERMINAL_NODE_IMPL; is_public: BOOLEAN) is
      local
         function_name: FIXED_STRING
      do
         if definition.count = 5 then -- const
            check is_public end
            definition.node_at(2).accept(Current)
            function_name := identifier.as_name.intern
            definition.node_at(4).accept(Current)
            last_value.set_public(True)
            last_value.set_constant(True)
            current_context.add_value(function_name, last_value)
         else
            definition.node_at(1).accept(Current)
            function_name := identifier.as_name.intern
            definition.node_at(3).accept(Current)
            last_value.set_public(is_public)
            current_context.add_value(function_name, last_value)
         end
      end

feature {}
   play_score (score: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_context: like current_context
      do
         old_context := current_context
         score.node_at(1).accept(Current)
         create {MIXUP_SCORE} current_context.make(name, old_context)
         score.node_at(2).accept(Current)
         root_context := current_context
         current_context := old_context
      end

   play_book (book: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_context: like current_context
      do
         old_context := current_context
         book.node_at(1).accept(Current)
         create {MIXUP_BOOK} current_context.make(name, old_context)
         book.node_at(2).accept(Current)
         root_context := current_context
         current_context := old_context
      end

   play_partitur (partitur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_context: like current_context
      do
         old_context := current_context
         partitur.node_at(1).accept(Current)
         create {MIXUP_PARTITUR} current_context.make(name, old_context)
         partitur.node_at(2).accept(Current)
         root_context := current_context
         current_context := old_context
      end

   play_partitur_content (partitur_content: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         partitur_content.accept_all(Current)
      end

   play_instrument (instrument: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_context: like current_context
         voices: MIXUP_VOICES
      do
         old_context := current_context
         instrument.node_at(1).accept(Current)
         create current_instrument.make(name, old_context, absolute_reference)
         current_context := current_instrument
         last_compound_music := Void
         instrument.node_at(2).accept(Current)
         instrument.node_at(3).accept(Current)
         voices ::= last_compound_music
         current_instrument.set_voices(voices)
         current_context := old_context
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

feature {}
   make is
      do
      end

end
