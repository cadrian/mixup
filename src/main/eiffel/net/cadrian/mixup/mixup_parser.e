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
      local
         old_compound_music: like last_compound_music
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
         when "Music" then
            old_compound_music := last_compound_music
            last_compound_music := Void
            node.node_at(1).accept(Current)
            create {MIXUP_MUSIC_VALUE} last_value.make(last_compound_music)
            if current_instrument = Void or else old_compound_music /= Void then
               last_compound_music := old_compound_music
            end
         when "Lyrics" then
            node.node_at(1).accept(Current)
         when "Instrument" then
            play_instrument(node)
         when "Next_Bar" then
            play_next_bar(node)
         when "Up_Staff" then
            play_up_staff(node)
         when "Down_Staff" then
            play_down_staff(node)
         when "Extern_Notes" then
            play_extern_music(node)
         when "Extern_Syllable" then
            play_extern_syllables(node)
         when "Position" then
            build_dynamics_position(node)
         when "Dynamic_Identifier" then
            build_dynamic_identifier(node)
         when "Dynamic_String" then
            build_dynamic_string(node)
         when "Dynamic_Hairpin_Crescendo" then
            build_dynamic_hairpin_crescendo(node)
         when "Dynamic_Hairpin_Decrescendo" then
            build_dynamic_hairpin_decrescendo(node)
         when "Dynamic_End" then
            build_dynamic_end(node)
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
         when "Xuplet_Spec" then
            read_xuplet_spec(node)
         when "Strophe" then
            play_strophe(node)
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
         when "KW syllable" then
            last_string := node.image.image
         when "KW string" then
            string_image ::= node.image
            last_string := string_image.image
            create {MIXUP_STRING} last_value.make(string_image.decoded, last_string)
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
            last_note_head.copy(node.image.image)
         else
            -- skipped
         end
      end

feature {}
   root_context: MIXUP_CONTEXT
   name: FIXED_STRING
   current_identifier: MIXUP_IDENTIFIER
   last_identifier: MIXUP_IDENTIFIER
   last_value: MIXUP_VALUE
   last_values: COLLECTION[MIXUP_VALUE]
   last_note_length: INTEGER_64
   last_note_head: STRING is ""
   note_heads: COLLECTION[FIXED_STRING]
   last_compound_music: MIXUP_COMPOUND_MUSIC
   current_context: MIXUP_CONTEXT
   last_string: STRING
   last_xuplet_numerator: INTEGER_64
   last_xuplet_denominator: INTEGER_64
   last_xuplet_text: FIXED_STRING

   build_identifier (dot_identifier: MIXUP_LIST_NODE_IMPL) is
      local
         old_identifier: like current_identifier
      do
         old_identifier := current_identifier
         create current_identifier.make
         dot_identifier.accept_all(Current)
         last_value := current_identifier
         last_identifier := current_identifier
         current_identifier := old_identifier
      end

   build_identifier_part (identifier_part: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         identifier_part.node_at(0).accept(Current)
         current_identifier.add_identifier_part(name)
         identifier_part.node_at(1).accept(Current)
      end

   build_identifier_args (identifier_args: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         if not identifier_args.is_empty then
            last_values := Void
            identifier_args.node_at(1).accept(Current)
            current_identifier.set_args(last_values)
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
         i: INTEGER; values: like last_values
      do
         create {FAST_ARRAY[MIXUP_VALUE]} values.with_capacity((value_list.count + 1) // 2)
         from
            i := value_list.lower
         until
            i > value_list.upper
         loop
            value_list.item(i).accept(Current)
            values.add_last(last_value)
            i := i + 1
         end
         last_values := values
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

         if old_compound_music /= Void then
            old_compound_music.add_music(voices)
            last_compound_music := old_compound_music
         end
      end

   absolute_reference: MIXUP_NOTE_HEAD is
      once
         Result.set("a", 4)
      end

   read_xuplet_spec (spec: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         int: MIXUP_INTEGER; str: MIXUP_STRING; string: STRING
      do
         if spec.is_empty then
            last_xuplet_numerator := 0
            last_xuplet_denominator := 0
            last_xuplet_text := Void
         else
            spec.node_at(0).accept(Current)
            int ::= last_value
            last_xuplet_numerator := int.value
            spec.node_at(2).accept(Current)
            last_xuplet_denominator := int.value
            if spec.count = 3 then
               string := once ""
               string.clear_count
               last_xuplet_numerator.append_in(string)
               last_xuplet_text := string.intern
            else
               spec.node_at(3).accept(Current)
               str ::= last_value
               last_xuplet_text := str.value
            end
         end
      end

feature {} -- Functions
   last_function: MIXUP_FUNCTION

   build_function_native (function_native: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         string: MIXUP_STRING; str: STRING
      do
         function_native.node_at(1).accept(Current)
         string ::= last_value
         str := once ""
         str.clear_count
         str.append(string.value)
         create {MIXUP_NATIVE_FUNCTION} last_function.make(string.value, native_provider.item(str))
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
            function_name := last_identifier.as_name.intern
            definition.node_at(4).accept(Current)
            last_value.set_public(True)
            last_value.set_constant(True)
            current_context.add_value(function_name, last_value)
         else
            definition.node_at(1).accept(Current)
            function_name := last_identifier.as_name.intern
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
         if root_context = Void then
            root_context := current_context
         end
         score.node_at(2).accept(Current)
         current_context := old_context
      end

   play_book (book: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_context: like current_context
      do
         old_context := current_context
         book.node_at(1).accept(Current)
         create {MIXUP_BOOK} current_context.make(name, old_context)
         if root_context = Void then
            root_context := current_context
         end
         book.node_at(2).accept(Current)
         current_context := old_context
      end

   play_partitur (partitur: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         old_context: like current_context
      do
         old_context := current_context
         partitur.node_at(1).accept(Current)
         create {MIXUP_PARTITUR} current_context.make(name, old_context)
         if root_context = Void then
            root_context := current_context
         end
         partitur.node_at(2).accept(Current)
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
         if root_context = Void then
            root_context := current_context
         end
         check
            current_instrument = Void
            last_compound_music = Void
         end
         instrument.node_at(2).accept(Current)
         instrument.node_at(3).accept(Current)
         voices ::= last_compound_music
         current_instrument.set_voices(voices)
         last_compound_music := Void
         current_context := old_context
         current_instrument := Void
      end

   play_next_bar (next_bar: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_compound_music.add_bar(Void)
      end

   play_up_staff (up_staff: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_compound_music.up_staff
      end

   play_down_staff (down_staff: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         last_compound_music.down_staff
      end

   play_extern_music (music: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         music.node_at(1).accept(Current)
         last_compound_music.add_music(create {MIXUP_MUSIC_IDENTIFIER}.make(last_identifier))
      end

   play_group (group: MIXUP_NON_TERMINAL_NODE_IMPL; grouped_music: MIXUP_GROUPED_MUSIC) is
      local
         old_compound_music: like last_compound_music
         xnumerator, xdenominator: INTEGER_64; xtext: FIXED_STRING
      do
         old_compound_music := last_compound_music

         group.node_at(1).accept(Current)
         xnumerator := last_xuplet_numerator
         xdenominator := last_xuplet_denominator
         xtext := last_xuplet_text

         last_compound_music := grouped_music
         group.node_at(2).accept(Current)
         old_compound_music.add_music(grouped_music)

         if xtext /= Void then
            grouped_music.set_xuplet(xnumerator, xdenominator, xtext)
         end
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
         create {FAST_ARRAY[FIXED_STRING]} note_heads.make(0)
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
      local
         token: MIXUP_TERMINAL_NODE_IMPL
      do
         note_head.node_at(0).accept(Current)
         if note_head.count > 1 then
            inspect
               last_note_head.first
            when 'r', 'R' then
               not_yet_implemented -- error: unexpected octave change for rest
            else
               token ::= note_head.node_at(1)
               last_note_head.append(token.image.image)
               if note_head.count = 3 then
                  token ::= note_head.node_at(2)
                  last_note_head.append(token.image.image)
               end
            end
         end
         note_heads.add_last(last_note_head.intern)
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
               last_note_length := number.value
               inspect
                  last_note_length
               when 1, 2, 4, 8, 16, 32, 64 then
                  last_note_length := {INTEGER_64 256} // last_note_length -- make it divisible by 4 (because of dots), and restore a correct order in lengths
                  if note_length.count > 1 then
                     note_length.node_at(1).accept(Current)
                  end
               else
                  not_yet_implemented -- error: invalid note length
               end
            else
               not_yet_implemented -- error: invalid note length
            end
         end
      end

feature {} -- Dynamics
   last_position: FIXED_STRING
   last_dynamics: MIXUP_DYNAMICS

   build_dynamics_position (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      local
         position: MIXUP_TERMINAL_NODE_IMPL
      do
         if dynamic.is_empty then
            last_position := Void
         else
            position ::= dynamic.node_at(0)
            last_position := position.image.image.intern
         end
      end

   build_dynamic_identifier (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         dynamic.node_at(0).accept(Current)
         create last_dynamics.make(name.intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_string (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         dynamic.node_at(0).accept(Current)
         create last_dynamics.make(last_string.intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_hairpin_crescendo (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create last_dynamics.make((once "<").intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_hairpin_decrescendo (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create last_dynamics.make((once ">").intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

   build_dynamic_end (dynamic: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         create last_dynamics.make((once "end").intern, last_position)
         last_compound_music.add_music(last_dynamics)
      end

feature {}
   current_instrument: MIXUP_INSTRUMENT

   play_notes (notes: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         notes.accept_all(Current)
      end

   play_strophe (strophe: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         current_instrument.next_strophe
         strophe.node_at(1).accept(Current)
      end

   play_syllable (syllable: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         syllable.accept_all(Current)
         current_instrument.add_syllable(last_string)
      end

   play_extern_syllables (syllables: MIXUP_NON_TERMINAL_NODE_IMPL) is
      do
         syllables.node_at(1).accept(Current)
         current_instrument.add_extern_syllables(last_identifier)
      end

feature {}
   make (a_native_provider: like native_provider) is
      require
         a_native_provider /= Void
      do
         native_provider := a_native_provider
      ensure
         native_provider = a_native_provider
      end

   native_provider: MIXUP_NATIVE_PROVIDER

end
